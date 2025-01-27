;; Licensing Contract

(define-map licenses
  { license-id: uint }
  {
    content-id: uint,
    licensee: principal,
    license-type: (string-ascii 20),
    start-date: uint,
    end-date: uint,
    price: uint
  }
)

(define-data-var license-nonce uint u0)

(define-public (create-license (content-id uint) (license-type (string-ascii 20)) (duration uint) (price uint))
  (let
    ((new-id (+ (var-get license-nonce) u1)))
    (map-set licenses
      { license-id: new-id }
      {
        content-id: content-id,
        licensee: tx-sender,
        license-type: license-type,
        start-date: block-height,
        end-date: (+ block-height duration),
        price: price
      }
    )
    (var-set license-nonce new-id)
    (ok new-id)
  )
)

(define-read-only (get-license (license-id uint))
  (map-get? licenses { license-id: license-id })
)

(define-read-only (is-license-valid (license-id uint))
  (match (get-license license-id)
    license (< block-height (get end-date license))
    false
  )
)

(define-read-only (get-license-count)
  (var-get license-nonce)
)

