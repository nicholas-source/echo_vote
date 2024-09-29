;; EchoVote: A decentralized voting system
;; This contract allows for creating, voting on, and managing proposals

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))
(define-constant err-already-voted (err u101))
(define-constant err-proposal-not-active (err u102))
(define-constant err-invalid-vote (err u103))
(define-constant err-invalid-title (err u104))
(define-constant err-invalid-description (err u105))
(define-constant err-invalid-start-block (err u106))
(define-constant err-invalid-end-block (err u107))
(define-constant err-proposal-ended (err u108))
(define-constant err-proposal-not-found (err u404))

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
    is-active: bool,
    total-votes: uint
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

;; Private functions

;; Validate text length
(define-private (validate-text (text (string-utf8 256)))
  (let ((length (len text)))
    (and (> length u0) (<= length u256))
  )
)

;; Validate long text length
(define-private (validate-long-text (text (string-utf8 1024)))
  (let ((length (len text)))
    (and (> length u0) (<= length u1024))
  )
)

;; Validate block range
(define-private (validate-blocks (start-block uint) (end-block uint))
  (let ((current-block block-height))
    (and 
      (>= start-block current-block)
      (> end-block start-block)
    )
  )
)

;; Check if proposal is active
(define-private (is-proposal-active (proposal-id uint))
  (match (map-get? proposals proposal-id)
    proposal (and 
               (get is-active proposal)
               (>= block-height (get start-block proposal))
               (< block-height (get end-block proposal))
             )
    false
  )
)

;; Increment vote count for a specific option
(define-private (increment-vote-count (proposal-id uint) (vote-option uint))
  (let
    (
      (current-count (default-to u0 (map-get? vote-counts { proposal-id: proposal-id, option: vote-option })))
      (new-count (+ current-count u1))
    )
    (map-set vote-counts { proposal-id: proposal-id, option: vote-option } new-count)
    (increment-total-votes proposal-id)
  )
)

;; Increment total votes for a proposal
(define-private (increment-total-votes (proposal-id uint))
  (match (map-get? proposals proposal-id)
    proposal (begin
      (map-set proposals proposal-id 
        (merge proposal { total-votes: (+ (get total-votes proposal) u1) })
      )
      true
    )
    false
  )
)

;; Public functions

;; Create a new proposal
(define-public (create-proposal (title (string-utf8 256)) (description (string-utf8 1024)) (start-block uint) (end-block uint))
  (let
    (
      (new-proposal-id (+ (var-get proposal-count) u1))
    )
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (asserts! (validate-text title) err-invalid-title)
    (asserts! (validate-long-text description) err-invalid-description)
    (asserts! (validate-blocks start-block end-block) err-invalid-start-block)
    (map-set proposals new-proposal-id
      {
        title: title,
        description: description,
        creator: tx-sender,
        start-block: start-block,
        end-block: end-block,
        is-active: true,
        total-votes: u0
      }
    )
    (var-set proposal-count new-proposal-id)
    (ok new-proposal-id)
  )
)

;; Cast a vote on a proposal
(define-public (vote (proposal-id uint) (vote-option uint))
  (let
    (
      (proposal (unwrap! (map-get? proposals proposal-id) err-proposal-not-found))
    )
    (asserts! (is-proposal-active proposal-id) err-proposal-not-active)
    (asserts! (is-none (map-get? votes { proposal-id: proposal-id, voter: tx-sender })) err-already-voted)
    (asserts! (and (>= vote-option u1) (<= vote-option u5)) err-invalid-vote)
    
    (map-set votes { proposal-id: proposal-id, voter: tx-sender } vote-option)
    (increment-vote-count proposal-id vote-option)
    (ok true)
  )
)

;; End an active proposal
(define-public (end-proposal (proposal-id uint))
  (let
    (
      (proposal (unwrap! (map-get? proposals proposal-id) err-proposal-not-found))
    )
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (asserts! (>= block-height (get end-block proposal)) err-proposal-not-active)
    (map-set proposals proposal-id (merge proposal { is-active: false }))
    (ok true)
  )
)

;; Read-only functions

;; Get proposal details
(define-read-only (get-proposal (proposal-id uint))
  (ok (unwrap! (map-get? proposals proposal-id) err-proposal-not-found))
)

;; Get a user's vote for a proposal
(define-read-only (get-vote (proposal-id uint) (voter principal))
  (ok (map-get? votes { proposal-id: proposal-id, voter: voter }))
)

;; Get vote count for a specific option
(define-read-only (get-vote-count (proposal-id uint) (vote-option uint))
  (ok (default-to u0 (map-get? vote-counts { proposal-id: proposal-id, option: vote-option })))
)

;; Get total votes for a proposal
(define-read-only (get-total-votes (proposal-id uint))
  (match (map-get? proposals proposal-id)
    proposal (ok (get total-votes proposal))
    (err err-proposal-not-found)
  )
)