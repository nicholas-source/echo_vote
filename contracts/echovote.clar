;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))
(define-constant err-already-voted (err u101))
(define-constant err-proposal-not-active (err u102))
(define-constant err-invalid-vote (err u103))

;; Data variables
(define-data-var proposal-count uint u0)

;; Data maps
(define-map proposals
  uint
  {
    title: (string-utf8 256),
    description: (string-utf8 1024),
    creator: principal,
    start-block: uint,
    end-block: uint,
    is-active: bool
  }
)

(define-map votes
  { proposal-id: uint, voter: principal }
  uint
)

(define-map vote-counts
  { proposal-id: uint, option: uint }
  uint
)

;; Public functions
(define-public (create-proposal (title (string-utf8 256)) (description (string-utf8 1024)) (start-block uint) (end-block uint))
  (let
    (
      (new-proposal-id (+ (var-get proposal-count) u1))
    )
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (map-set proposals new-proposal-id
      {
        title: title,
        description: description,
        creator: tx-sender,
        start-block: start-block,
        end-block: end-block,
        is-active: true
      }
    )
    (var-set proposal-count new-proposal-id)
    (ok new-proposal-id)
  )
)

(define-public (vote (proposal-id uint) (vote-option uint))
  (let
    (
      (proposal (unwrap! (map-get? proposals proposal-id) err-proposal-not-active))
      (current-block block-height)
    )
    (asserts! (>= current-block (get start-block proposal)) err-proposal-not-active)
    (asserts! (<= current-block (get end-block proposal)) err-proposal-not-active)
    (asserts! (get is-active proposal) err-proposal-not-active)
    (asserts! (is-none (map-get? votes { proposal-id: proposal-id, voter: tx-sender })) err-already-voted)
    (asserts! (and (>= vote-option u1) (<= vote-option u5)) err-invalid-vote)
    
    (map-set votes { proposal-id: proposal-id, voter: tx-sender } vote-option)
    (map-set vote-counts
      { proposal-id: proposal-id, option: vote-option }
      (+ (default-to u0 (map-get? vote-counts { proposal-id: proposal-id, option: vote-option })) u1)
    )
    (ok true)
  )
)

(define-read-only (get-proposal (proposal-id uint))
  (map-get? proposals proposal-id)
)

(define-read-only (get-vote (proposal-id uint) (voter principal))
  (map-get? votes { proposal-id: proposal-id, voter: voter })
)

(define-read-only (get-vote-count (proposal-id uint) (vote-option uint))
  (default-to u0 (map-get? vote-counts { proposal-id: proposal-id, option: vote-option }))
)

(define-read-only (get-total-votes (proposal-id uint))
  (fold + 
    (list 
      (get-vote-count proposal-id u1)
      (get-vote-count proposal-id u2)
      (get-vote-count proposal-id u3)
      (get-vote-count proposal-id u4)
      (get-vote-count proposal-id u5)
    )
    u0
  )
)