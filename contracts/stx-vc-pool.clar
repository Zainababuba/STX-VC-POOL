;; Crowd-Driven VC Pool Smart Contract
;; Manages decentralized venture capital pools with voting and investment distribution

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant MIN_CONTRIBUTION u1000000) ;; Minimum contribution in microSTX
(define-constant VOTING_PERIOD u144) ;; ~24 hours in blocks
(define-constant PROPOSAL_THRESHOLD u100000000) ;; Minimum pool size for proposals

;; Error codes
(define-constant ERR_NOT_AUTHORIZED (err u100))
(define-constant ERR_INSUFFICIENT_FUNDS (err u101))
(define-constant ERR_POOL_NOT_FOUND (err u102))
(define-constant ERR_INVALID_AMOUNT (err u103))
(define-constant ERR_ALREADY_VOTED (err u104))
(define-constant ERR_VOTING_CLOSED (err u105))
(define-constant ERR_BELOW_THRESHOLD (err u106))

;; Data Maps
(define-map pools
    { pool-id: uint }
    {
        total-funds: uint,
        active: bool,
        creator: principal,
        created-at: uint
    }
)

(define-map contributions
    { pool-id: uint, contributor: principal }
    { amount: uint }
)

(define-map proposals
    { pool-id: uint, proposal-id: uint }
    {
        startup: principal,
        amount: uint,
        description: (string-utf8 256),
        votes-for: uint,
        votes-against: uint,
        status: (string-utf8 20),
        created-at: uint
    }
)

(define-map votes
    { pool-id: uint, proposal-id: uint, voter: principal }
    { vote: bool }
)

;; Pool counter
(define-data-var pool-counter uint u0)
(define-data-var proposal-counter uint u0)

;; Read-only functions
(define-read-only (get-pool (pool-id uint))
    (map-get? pools { pool-id: pool-id })
)

(define-read-only (get-contribution (pool-id uint) (contributor principal))
    (map-get? contributions { pool-id: pool-id, contributor: contributor })
)

(define-read-only (get-proposal (pool-id uint) (proposal-id uint))
    (map-get? proposals { pool-id: pool-id, proposal-id: proposal-id })
)

(define-read-only (get-vote (pool-id uint) (proposal-id uint) (voter principal))
    (map-get? votes { pool-id: pool-id, proposal-id: proposal-id, voter: voter })
)
