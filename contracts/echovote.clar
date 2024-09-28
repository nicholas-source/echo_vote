;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))
(define-constant err-already-voted (err u101))
(define-constant err-proposal-not-active (err u102))
(define-constant err-invalid-vote (err u103))