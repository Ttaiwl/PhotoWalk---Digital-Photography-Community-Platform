;; PhotoWalk - Digital Photography Community Platform
;; A blockchain-based platform for photo walks, shot logs,
;; and photographer community rewards

;; Contract constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-found (err u101))
(define-constant err-already-exists (err u102))
(define-constant err-unauthorized (err u103))
(define-constant err-invalid-input (err u104))

;; Token constants
(define-constant token-name "PhotoWalk Lens Token")
(define-constant token-symbol "PLT")
(define-constant token-decimals u6)
(define-constant token-max-supply u50000000000) ;; 50k tokens with 6 decimals

;; Reward amounts (in micro-tokens)
(define-constant reward-shoot u2800000) ;; 2.8 PLT
(define-constant reward-walk u3400000) ;; 3.4 PLT
(define-constant reward-milestone u8600000) ;; 8.6 PLT

;; Data variables
(define-data-var total-supply uint u0)
(define-data-var next-walk-id uint u1)
(define-data-var next-shoot-id uint u1)

;; Token balances
(define-map token-balances principal uint)

;; Photographer profiles
(define-map photographer-profiles
  principal
  {
    username: (string-ascii 24),
    photo-style: (string-ascii 12), ;; "portrait", "landscape", "street", "macro", "wildlife"
    shoots-logged: uint,
    walks-organized: uint,
    photos-taken: uint,
    skill-rating: uint, ;; 1-5
    join-date: uint
  }
)

;; Photo walks
(define-map photo-walks
  uint
  {
    walk-title: (string-ascii 8),
    location-type: (string-ascii 10), ;; "urban", "nature", "beach", "mountain", "studio"
    theme: (string-ascii 8), ;; "golden", "blue", "street", "macro", "portrait"
    duration: uint, ;; hours
    max-shooters: uint,
    lighting: (string-ascii 6), ;; "natural", "flash", "mixed"
    organizer: principal,
    shoot-count: uint,
    quality-score: uint ;; average quality
  }
)

;; Shoot logs
(define-map shoot-logs
  uint
  {
    walk-id: uint,
    photographer: principal,
    camera-used: (string-ascii 8),
    photos-captured: uint,
    focal-length: uint, ;; mm
    aperture: uint, ;; f-stop * 10 (f/2.8 = 28)
    shutter-speed: uint, ;; 1/seconds
    iso-setting: uint,
    composition: uint, ;; 1-5
    shoot-notes: (string-ascii 15),
    shoot-date: uint,
    satisfied: bool
  }
)

;; Walk reviews
(define-map walk-reviews
  { walk-id: uint, reviewer: principal }
  {
    rating: uint, ;; 1-10
    review-text: (string-ascii 15),
    inspiration: (string-ascii 4), ;; "high", "good", "fair", "low"
    review-date: uint,
    sharp-votes: uint
  }
)

;; Photographer milestones
(define-map photographer-milestones
  { photographer: principal, milestone: (string-ascii 12) }
  {
    achievement-date: uint,
    shoot-count: uint
  }
)

;; Helper function to get or create profile
(define-private (get-or-create-profile (photographer principal))
  (match (map-get? photographer-profiles photographer)
    profile profile
    {
      username: "",
      photo-style: "street",
      shoots-logged: u0,
      walks-organized: u0,
      photos-taken: u0,
      skill-rating: u1,
      join-date: stacks-block-height
    }
  )
)

;; Token functions
(define-read-only (get-name)
  (ok token-name)
)

(define-read-only (get-symbol)
  (ok token-symbol)
)

(define-read-only (get-decimals)
  (ok token-decimals)
)

(define-read-only (get-balance (user principal))
  (ok (default-to u0 (map-get? token-balances user)))
)

(define-private (mint-tokens (recipient principal) (amount uint))
  (let (
    (current-balance (default-to u0 (map-get? token-balances recipient)))
    (new-balance (+ current-balance amount))
    (new-total-supply (+ (var-get total-supply) amount))
  )
    (asserts! (<= new-total-supply token-max-supply) err-invalid-input)
    (map-set token-balances recipient new-balance)
    (var-set total-supply new-total-supply)
    (ok amount)
  )
)

;; Organize photo walk
(define-public (organize-photo-walk (walk-title (string-ascii 8)) (location-type (string-ascii 10)) (theme (string-ascii 8)) (duration uint) (max-shooters uint) (lighting (string-ascii 6)))
  (let (
    (walk-id (var-get next-walk-id))
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len walk-title) u0) err-invalid-input)
    (asserts! (> duration u0) err-invalid-input)
    (asserts! (> max-shooters u0) err-invalid-input)
    
    (map-set photo-walks walk-id {
      walk-title: walk-title,
      location-type: location-type,
      theme: theme,
      duration: duration,
      max-shooters: max-shooters,
      lighting: lighting,
      organizer: tx-sender,
      shoot-count: u0,
      quality-score: u0
    })
    
    ;; Update profile
    (map-set photographer-profiles tx-sender
      (merge profile {walks-organized: (+ (get walks-organized profile) u1)})
    )
    
    ;; Award walk organization tokens
    (try! (mint-tokens tx-sender reward-walk))
    
    (var-set next-walk-id (+ walk-id u1))
    (print {action: "photo-walk-organized", walk-id: walk-id, organizer: tx-sender})
    (ok walk-id)
  )
)

;; Log photo shoot
(define-public (log-shoot (walk-id uint) (camera-used (string-ascii 8)) (photos-captured uint) (focal-length uint) (aperture uint) (shutter-speed uint) (iso-setting uint) (composition uint) (shoot-notes (string-ascii 15)) (satisfied bool))
  (let (
    (shoot-id (var-get next-shoot-id))
    (photo-walk (unwrap! (map-get? photo-walks walk-id) err-not-found))
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> photos-captured u0) err-invalid-input)
    (asserts! (> focal-length u0) err-invalid-input)
    (asserts! (> aperture u0) err-invalid-input)
    (asserts! (> shutter-speed u0) err-invalid-input)
    (asserts! (and (>= composition u1) (<= composition u5)) err-invalid-input)
    
    (map-set shoot-logs shoot-id {
      walk-id: walk-id,
      photographer: tx-sender,
      camera-used: camera-used,
      photos-captured: photos-captured,
      focal-length: focal-length,
      aperture: aperture,
      shutter-speed: shutter-speed,
      iso-setting: iso-setting,
      composition: composition,
      shoot-notes: shoot-notes,
      shoot-date: stacks-block-height,
      satisfied: satisfied
    })
    
    ;; Update walk stats if satisfied
    (if satisfied
      (let (
        (new-shoot-count (+ (get shoot-count photo-walk) u1))
        (current-quality (* (get quality-score photo-walk) (get shoot-count photo-walk)))
        (new-quality-score (/ (+ current-quality composition) new-shoot-count))
      )
        (map-set photo-walks walk-id
          (merge photo-walk {
            shoot-count: new-shoot-count,
            quality-score: new-quality-score
          })
        )
        true
      )
      true
    )
    
    ;; Update profile
    (if satisfied
      (begin
        (map-set photographer-profiles tx-sender
          (merge profile {
            shoots-logged: (+ (get shoots-logged profile) u1),
            photos-taken: (+ (get photos-taken profile) photos-captured),
            skill-rating: (+ (get skill-rating profile) (/ composition u12))
          })
        )
        (try! (mint-tokens tx-sender reward-shoot))
        true
      )
      (begin
        (try! (mint-tokens tx-sender (/ reward-shoot u3)))
        true
      )
    )
    
    (var-set next-shoot-id (+ shoot-id u1))
    (print {action: "shoot-logged", shoot-id: shoot-id, walk-id: walk-id})
    (ok shoot-id)
  )
)

;; Write walk review
(define-public (write-review (walk-id uint) (rating uint) (review-text (string-ascii 15)) (inspiration (string-ascii 4)))
  (let (
    (photo-walk (unwrap! (map-get? photo-walks walk-id) err-not-found))
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (and (>= rating u1) (<= rating u10)) err-invalid-input)
    (asserts! (> (len review-text) u0) err-invalid-input)
    (asserts! (is-none (map-get? walk-reviews {walk-id: walk-id, reviewer: tx-sender})) err-already-exists)
    
    (map-set walk-reviews {walk-id: walk-id, reviewer: tx-sender} {
      rating: rating,
      review-text: review-text,
      inspiration: inspiration,
      review-date: stacks-block-height,
      sharp-votes: u0
    })
    
    (print {action: "review-written", walk-id: walk-id, reviewer: tx-sender})
    (ok true)
  )
)

;; Vote review sharp
(define-public (vote-sharp (walk-id uint) (reviewer principal))
  (let (
    (review (unwrap! (map-get? walk-reviews {walk-id: walk-id, reviewer: reviewer}) err-not-found))
  )
    (asserts! (not (is-eq tx-sender reviewer)) err-unauthorized)
    
    (map-set walk-reviews {walk-id: walk-id, reviewer: reviewer}
      (merge review {sharp-votes: (+ (get sharp-votes review) u1)})
    )
    
    (print {action: "review-voted-sharp", walk-id: walk-id, reviewer: reviewer})
    (ok true)
  )
)

;; Update photo style
(define-public (update-photo-style (new-photo-style (string-ascii 12)))
  (let (
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len new-photo-style) u0) err-invalid-input)
    
    (map-set photographer-profiles tx-sender (merge profile {photo-style: new-photo-style}))
    
    (print {action: "photo-style-updated", photographer: tx-sender, style: new-photo-style})
    (ok true)
  )
)

;; Claim milestone
(define-public (claim-milestone (milestone (string-ascii 12)))
  (let (
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (is-none (map-get? photographer-milestones {photographer: tx-sender, milestone: milestone})) err-already-exists)
    
    ;; Check milestone requirements
    (let (
      (milestone-met
        (if (is-eq milestone "shooter-115") (>= (get shoots-logged profile) u115)
        (if (is-eq milestone "guide-22") (>= (get walks-organized profile) u22)
        false)))
    )
      (asserts! milestone-met err-unauthorized)
      
      ;; Record milestone
      (map-set photographer-milestones {photographer: tx-sender, milestone: milestone} {
        achievement-date: stacks-block-height,
        shoot-count: (get shoots-logged profile)
      })
      
      ;; Award milestone tokens
      (try! (mint-tokens tx-sender reward-milestone))
      
      (print {action: "milestone-claimed", photographer: tx-sender, milestone: milestone})
      (ok true)
    )
  )
)

;; Update username
(define-public (update-username (new-username (string-ascii 24)))
  (let (
    (profile (get-or-create-profile tx-sender))
  )
    (asserts! (> (len new-username) u0) err-invalid-input)
    (map-set photographer-profiles tx-sender (merge profile {username: new-username}))
    (print {action: "username-updated", photographer: tx-sender})
    (ok true)
  )
)

;; Read-only functions
(define-read-only (get-photographer-profile (photographer principal))
  (map-get? photographer-profiles photographer)
)

(define-read-only (get-photo-walk (walk-id uint))
  (map-get? photo-walks walk-id)
)

(define-read-only (get-shoot-log (shoot-id uint))
  (map-get? shoot-logs shoot-id)
)

(define-read-only (get-walk-review (walk-id uint) (reviewer principal))
  (map-get? walk-reviews {walk-id: walk-id, reviewer: reviewer})
)

(define-read-only (get-milestone (photographer principal) (milestone (string-ascii 12)))
  (map-get? photographer-milestones {photographer: photographer, milestone: milestone})
)