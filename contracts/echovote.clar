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