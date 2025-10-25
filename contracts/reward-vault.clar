;; ===============================================================
;; Contract: RewardVault.clar
;; Description: A decentralized vault that allows an owner or DAO
;;              to create reward pools and distribute STX rewards
;;              to eligible participants.
;; ===============================================================

;; ---------------------------
;; Constants and Errors
;; ---------------------------

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_INVALID_REWARD (err u101))
(define-constant ERR_NO_BALANCE (err u102))
(define-constant ERR_ALREADY_CLAIMED (err u103))
(define-constant ERR_TRANSFER_FAILED (err u104))

;; ---------------------------
;; Data Structures
;; ---------------------------

;; Each reward pool: identified by a unique ID
(define-map reward-pools
  uint
  {
    creator: principal,
    total-amount: uint,
    remaining-amount: uint,
    is-active: bool
  }
)

;; Track user claims per pool
(define-map reward-claims
  {
    pool-id: uint,
    claimant: principal
  }
  bool
)

(define-data-var pool-id-counter uint u0)

;; ---------------------------
;; Public Functions
;; ---------------------------

;; Create a new reward pool
(define-public (create-pool (amount uint))
  (begin
    (unwrap! (stx-transfer? amount tx-sender (as-contract tx-sender)) ERR_TRANSFER_FAILED)
    (let (
          (id (+ (var-get pool-id-counter) u1))
         )
      (map-set reward-pools
        id
        {
          creator: tx-sender,
          total-amount: amount,
          remaining-amount: amount,
          is-active: true
        }
      )
      (var-set pool-id-counter id)
      ;; removed emoji and replaced to-utf8 with simple string message
      (ok "Reward pool created successfully")
    )
  )
)

;; Claim reward from a pool
(define-public (claim-reward (pool-id uint) (amount uint))
  (let (
        (pool (map-get? reward-pools pool-id))
        (claimed? (map-get? reward-claims {pool-id: pool-id, claimant: tx-sender}))
       )
    (if (is-none pool)
        ERR_INVALID_REWARD
        (let ((data (unwrap-panic pool)))
          (if (not (get is-active data))
              ERR_INVALID_REWARD
              (if (is-some claimed?)
                  ERR_ALREADY_CLAIMED
                  (if (> amount (get remaining-amount data))
                      ERR_NO_BALANCE
                      (begin
                        (unwrap! (stx-transfer? amount (as-contract tx-sender) tx-sender) ERR_TRANSFER_FAILED)
                        (map-set reward-claims {pool-id: pool-id, claimant: tx-sender} true)
                        (map-set reward-pools
                          pool-id
                          (merge data {remaining-amount: (- (get remaining-amount data) amount)}))
                        (ok "Reward claimed successfully.")
                      )
                  )
              )
          )
        )
    )
  )
)

;; Close a pool (only by creator)
(define-public (close-pool (pool-id uint))
  (let ((pool (map-get? reward-pools pool-id)))
    (if (is-none pool)
        ERR_INVALID_REWARD
        (let ((data (unwrap-panic pool)))
          (if (not (is-eq tx-sender (get creator data)))
              ERR_UNAUTHORIZED
              (begin
                (map-set reward-pools pool-id (merge data {is-active: false}))
                (ok "Reward pool closed.")
              )
          )
        )
    )
  )
)

;; ---------------------------
;; Read-Only Functions
;; ---------------------------

;; Get reward pool details
(define-read-only (get-pool (pool-id uint))
  (ok (map-get? reward-pools pool-id))
)

;; Check if a user has claimed from a pool
(define-read-only (has-claimed (pool-id uint) (user principal))
  (ok (default-to false (map-get? reward-claims {pool-id: pool-id, claimant: user})))
)

;; Get total number of pools
(define-read-only (get-total-pools)
  (ok (var-get pool-id-counter))
)
