;; echovote.clar

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
(define-private (validate-text (text (string-utf8 256)))
  (let ((length (len text)))
    (and (> length u0) (<= length u256))
  )
)

(define-private (validate-long-text (text (string-utf8 1024)))
  (let ((length (len text)))
    (and (> length u0) (<= length u1024))
  )
)

(define-private (validate-blocks (start-block uint) (end-block uint))
  (let ((current-block block-height))
    (and 
      (> start-block current-block)
      (> end-block start-block)
    )
  )
)

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

(define-private (increment-total-votes (proposal-id uint))
  (let
    (
      (proposal (unwrap! (map-get? proposals proposal-id) (err u404)))
      (new-total (+ (get total-votes proposal) u1))
    )
    (map-set proposals proposal-id (merge proposal { total-votes: new-total }))
  )
)

;; Public functions
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

(define-public (vote (proposal-id uint) (vote-option uint))
  (let
    (
      (proposal (unwrap! (map-get? proposals proposal-id) err-proposal-not-active))
      (current-block block-height)
    )
    (asserts! (>= current-block (get start-block proposal)) err-proposal-not-active)
    (asserts! (<= current-block (get end-block proposal)) err-proposal-ended)
    (asserts! (get is-active proposal) err-proposal-not-active)
    (asserts! (is-none (map-get? votes { proposal-id: proposal-id, voter: tx-sender })) err-already-voted)
    (asserts! (and (>= vote-option u1) (<= vote-option u5)) err-invalid-vote)
    
    (map-set votes { proposal-id: proposal-id, voter: tx-sender } vote-option)
    (increment-vote-count proposal-id vote-option)
    (ok true)
  )
)

(define-public (end-proposal (proposal-id uint))
  (let
    (
      (proposal (unwrap! (map-get? proposals proposal-id) err-proposal-not-active))
      (current-block block-height)
    )
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (asserts! (>= current-block (get end-block proposal)) err-proposal-not-active)
    (map-set proposals proposal-id (merge proposal { is-active: false }))
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
  (let
    (
      (proposal (unwrap! (map-get? proposals proposal-id) (err u404)))
    )
    (get total-votes proposal)
  )
)