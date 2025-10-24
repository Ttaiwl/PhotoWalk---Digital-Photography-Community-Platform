# PhotoWalk - Digital Photography Community Platform

[![Clarity Smart Contract](https://img.shields.io/badge/Clarity-Smart%20Contract-5546ff)](https://clarity-lang.org/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A blockchain-based platform for organizing photo walks, logging photography sessions, and building an engaged photographer community through tokenized rewards.

## 📸 Overview

PhotoWalk creates a decentralized ecosystem where photographers can organize group photo sessions, log their shoots with detailed technical metadata, share reviews, and earn rewards for active participation. The platform uses PLT (PhotoWalk Lens Token) to incentivize quality photography and community engagement.

## ✨ Key Features

### 🚶 Photo Walk Organization
- **Community Events**: Organize themed photography sessions
- **Detailed Planning**: Specify location type, theme, duration, and lighting conditions
- **Capacity Management**: Set maximum participant counts
- **Quality Tracking**: Automatic quality score calculation based on participant feedback

### 📷 Shot Logging System
- **Technical Metadata**: Record complete camera settings
  - Camera model
  - Focal length
  - Aperture (f-stop)
  - Shutter speed
  - ISO setting
- **Composition Rating**: Self-assess composition quality (1-5 scale)
- **Photo Count Tracking**: Log total photos captured per session
- **Satisfaction Indicator**: Mark shoots as satisfying or unsatisfying

### 🪙 Token Economics (PLT)
- **Token Name**: PhotoWalk Lens Token (PLT)
- **Symbol**: PLT
- **Decimals**: 6
- **Max Supply**: 50,000 PLT

#### Reward Structure
| Activity | Reward Amount | Condition |
|----------|---------------|-----------|
| Photo Shoot (Satisfied) | 2.8 PLT | Full reward for quality shoots |
| Photo Shoot (Unsatisfied) | 0.93 PLT | 1/3 reward for practice sessions |
| Walk Organization | 3.4 PLT | For organizing community events |
| Milestone Achievement | 8.6 PLT | For reaching career milestones |

### 🏆 Milestone System
Recognize photographer achievements:
- **"shooter-115"**: Complete 115 photo shoots
- **"guide-22"**: Organize 22 photo walks
- One-time rewards with permanent achievement records

### 👤 Photographer Profiles
Comprehensive tracking of:
- Username and preferred photo style
- Total shoots logged
- Walks organized
- Photos taken (cumulative count)
- Skill rating (progressive improvement)
- Join date and activity history

### ⭐ Review & Rating System
- **Walk Reviews**: Rate walks on 1-10 scale
- **Inspiration Tracking**: Categorize inspiration level (high, good, fair, low)
- **Community Voting**: "Sharp votes" system for helpful reviews
- **One Review Per Walk**: Ensures authentic feedback

### 🎨 Photography Styles Supported
- Portrait
- Landscape
- Street photography
- Macro
- Wildlife

## 🏗️ Technical Architecture

### Smart Contract Structure

```
PhotoWalk Contract
├── Token System (PLT)
│   ├── Minting Logic
│   ├── Balance Tracking
│   └── Supply Management
├── Photo Walk Management
│   ├── Event Creation
│   ├── Participant Tracking
│   └── Quality Scoring
├── Shoot Logging
│   ├── Technical Metadata
│   ├── Composition Rating
│   └── Profile Updates
├── Review System
│   ├── Rating Management
│   ├── Voting Mechanism
│   └── Duplicate Prevention
└── Milestone Tracking
    ├── Achievement Verification
    ├── Reward Distribution
    └── Permanent Records
```

### Data Maps

| Map | Purpose | Key Structure |
|-----|---------|---------------|
| `photographer-profiles` | User profiles and stats | `principal` |
| `photo-walks` | Walk event details | `uint` (walk-id) |
| `shoot-logs` | Photography session records | `uint` (shoot-id) |
| `walk-reviews` | Event reviews and ratings | `{walk-id, reviewer}` |
| `photographer-milestones` | Achievement tracking | `{photographer, milestone}` |
| `token-balances` | PLT holdings | `principal` |

### Innovative Features

#### 1. Dynamic Skill Rating
Skill rating increases based on composition scores:
```clarity
skill-rating: (+ (get skill-rating profile) (/ composition u12))
```
Progressive improvement tracking rewards consistent quality.

#### 2. Quality Score Averaging
Photo walks maintain rolling average quality:
```clarity
new-quality-score: (/ (+ current-quality composition) new-shoot-count)
```
Helps photographers find high-quality events.

#### 3. Satisfaction-Based Rewards
- Satisfied shoots: Full 2.8 PLT reward
- Unsatisfied shoots: Reduced 0.93 PLT reward
- Encourages honest self-assessment without penalizing experimentation

## 🚀 Getting Started

### Prerequisites
- Stacks wallet (Hiro Wallet, Xverse, etc.)
- STX for transaction fees
- Camera and passion for photography! 📷

### Contract Deployment

```bash
# Clone the repository
git clone https://github.com/yourusername/photowalk

# Install Clarinet
curl -L https://github.com/hirosystems/clarinet/releases/download/latest/clarinet-install.sh | sh

# Test the contract
clarinet test

# Deploy to testnet
clarinet deploy --testnet
```

### Quick Start Guide

#### 1. Organize Your First Photo Walk
```clarity
(contract-call? .photowalk organize-photo-walk
  "Sunset" ;; walk-title
  "urban" ;; location-type
  "golden" ;; theme
  u2 ;; duration (2 hours)
  u10 ;; max-shooters
  "natural" ;; lighting
)
```
**Earns**: 3.4 PLT

#### 2. Log a Photo Shoot
```clarity
(contract-call? .photowalk log-shoot
  u1 ;; walk-id
  "Canon5D" ;; camera-used
  u45 ;; photos-captured
  u50 ;; focal-length (50mm)
  u28 ;; aperture (f/2.8)
  u250 ;; shutter-speed (1/250s)
  u400 ;; iso-setting
  u4 ;; composition (1-5)
  "Great light!" ;; shoot-notes
  true ;; satisfied
)
```
**Earns**: 2.8 PLT (if satisfied) or 0.93 PLT (if unsatisfied)

#### 3. Write a Review
```clarity
(contract-call? .photowalk write-review
  u1 ;; walk-id
  u9 ;; rating (1-10)
  "Amazing vibes" ;; review-text
  "high" ;; inspiration
)
```

#### 4. Update Your Profile
```clarity
;; Set username
(contract-call? .photowalk update-username "NatureLens")

;; Set photo style
(contract-call? .photowalk update-photo-style "landscape")
```

## 📊 Token Economics Deep Dive

### Reward Philosophy
PhotoWalk's tokenomics balance three goals:
1. **Encourage Participation**: Rewards for every logged shoot
2. **Value Quality**: Higher rewards for satisfying sessions
3. **Build Community**: Bonus rewards for organizing events

### Supply Distribution Model
With 50,000 PLT max supply:
- **17,857** full photography sessions (at 2.8 PLT each)
- **14,706** photo walks organized (at 3.4 PLT each)
- **5,814** milestone achievements (at 8.6 PLT each)

### Earning Potential Examples

**Casual Photographer** (10 shoots/month):
- Monthly: 28 PLT
- Annual: 336 PLT

**Active Community Member** (25 shoots + 2 walks/month):
- Monthly: 76.8 PLT
- Annual: 921.6 PLT

**Professional Organizer** (50 shoots + 5 walks/month):
- Monthly: 157 PLT
- Annual: 1,884 PLT + Milestone bonuses

## 🎯 Use Cases

### For Hobbyist Photographers
- Track technical settings and improvement over time
- Join community photo walks
- Learn from other photographers' reviews
- Build portfolio documentation

### For Professional Photographers
- Organize paid or sponsored photo walks
- Build reputation through quality scores
- Document professional shoots for clients
- Network with other photographers

### For Photography Educators
- Organize student photo walks
- Track student progress through skill ratings
- Create themed learning experiences
- Build teaching reputation

### For Photography Clubs
- Coordinate club events
- Track member participation
- Reward active members
- Build club reputation on-chain

## 🔍 Technical Specifications

### Camera Settings Format

**Aperture**: Stored as f-stop × 10
- f/2.8 = 28
- f/4 = 40
- f/5.6 = 56

**Shutter Speed**: Stored as 1/seconds
- 1/250s = 250
- 1/1000s = 1000
- 1/60s = 60

**Focal Length**: In millimeters
- 24mm, 50mm, 85mm, 200mm, etc.

### String Constraints

| Field | Max Length | Purpose |
|-------|------------|---------|
| Username | 24 chars | Profile identifier |
| Walk Title | 8 chars | Event name |
| Camera | 8 chars | Camera model |
| Theme | 8 chars | Walk theme |
| Review Text | 15 chars | Review content |
| Shoot Notes | 15 chars | Session notes |
| Photo Style | 12 chars | Style preference |
| Location Type | 10 chars | Location category |
| Lighting | 6 chars | Lighting conditions |
| Inspiration | 4 chars | Inspiration level |

*Note: Tight constraints optimize for gas efficiency*

## 🔒 Security Features

### Access Control
- **Profile Updates**: Only owner can modify their profile
- **Review Protection**: Users cannot vote on their own reviews
- **Milestone Verification**: Automatic requirement checking

### Data Integrity
- **Duplicate Prevention**: One review per user per walk
- **One-Time Milestones**: Achievements claimable only once
- **Supply Cap**: Hard-coded 50,000 PLT maximum

### Input Validation
- Non-empty strings for titles and usernames
- Composition ratings bounded (1-5)
- Review ratings bounded (1-10)
- Positive values for duration, photos, technical settings

### Error Codes
| Code | Error | Description |
|------|-------|-------------|
| u100 | err-owner-only | Contract owner action required |
| u101 | err-not-found | Resource not found |
| u102 | err-already-exists | Duplicate entry prevented |
| u103 | err-unauthorized | Action not permitted |
| u104 | err-invalid-input | Invalid parameters |

## 📈 Platform Statistics

### Trackable Metrics
- Total photo walks organized
- Total shoots logged
- Total photos captured (cumulative)
- Average walk quality scores
- Review counts and ratings
- Milestone achievements
- Token distribution across users

### Quality Indicators
- **Walk Quality Score**: Rolling average of composition ratings
- **Skill Rating**: Progressive improvement tracking
- **Sharp Votes**: Community validation of reviews

## 🗺️ Roadmap

### Phase 1: Core Platform ✅
- [x] Photo walk organization
- [x] Shoot logging with technical metadata
- [x] Token reward system
- [x] Review and rating system
- [x] Milestone achievements

### Phase 2: Enhanced Features (Q2 2024)
- [ ] Photo upload and IPFS integration
- [ ] Equipment recommendations based on settings
- [ ] Weather integration for walks
- [ ] Advanced search and filtering
- [ ] Private/paid walks

### Phase 3: Community Growth (Q3 2024)
- [ ] Photographer matchmaking
- [ ] Equipment marketplace
- [ ] Tutorial and course system
- [ ] Photography challenges
- [ ] Seasonal competitions

### Phase 4: Advanced Features (Q4 2024)
- [ ] NFT minting for best photos
- [ ] DAO governance for platform
- [ ] Cross-chain integration
- [ ] Mobile app launch
- [ ] Pro subscription tiers

## 📝 API Reference

### Read-Only Functions

```clarity
;; Get photographer profile
(get-photographer-profile (photographer principal))
;; Returns: {username, photo-style, shoots-logged, walks-organized, 
;;           photos-taken, skill-rating, join-date}

;; Get photo walk details
(get-photo-walk (walk-id uint))
;; Returns: {walk-title, location-type, theme, duration, max-shooters,
;;           lighting, organizer, shoot-count, quality-score}

;; Get shoot log
(get-shoot-log (shoot-id uint))
;; Returns: Complete shoot metadata

;; Get walk review
(get-walk-review (walk-id uint) (reviewer principal))
;; Returns: {rating, review-text, inspiration, review-date, sharp-votes}

;; Get milestone status
(get-milestone (photographer principal) (milestone string-ascii))
;; Returns: {achievement-date, shoot-count}

;; Token functions
(get-balance (user principal))
(get-name)
(get-symbol)
(get-decimals)
```

### Public Functions

#### Walk Management
- `organize-photo-walk`: Create new photo walk event
- `write-review`: Review a completed walk
- `vote-sharp`: Vote on helpful reviews

#### Photography
- `log-shoot`: Record photography session
- `claim-milestone`: Claim achievement rewards

#### Profile
- `update-username`: Change display name
- `update-photo-style`: Update preferred style

## 🤝 Contributing

We welcome contributions! Areas of focus:
- Frontend development (React/Vue)
- Mobile app development
- Additional milestone types
- Photo storage integration
- Analytics and visualization

### Development Setup
```bash
# Install dependencies
npm install

# Run tests
clarinet test

# Check contract
clarinet check
```

## 💡 Best Practices

### For Organizers
1. Choose descriptive walk titles (within 8 char limit)
2. Select appropriate themes and locations
3. Set realistic participant caps
4. Organize regularly to build reputation

### For Photographers
1. Log all shoots, even unsuccessful ones
2. Be honest with satisfaction ratings
3. Include detailed technical notes
4. Review walks you attend
5. Vote on helpful reviews

### For Community Building
1. Share knowledge through reviews
2. Organize diverse walk types
3. Welcome beginners
4. Celebrate milestone achievements

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built on [Stacks Blockchain](https://www.stacks.co/)
- Inspired by the global photography community
- Thanks to all contributing photographers

## 📞 Contact & Support

- **Website**: https://photowalk.example
- **Discord**: https://discord.gg/photowalk
- **Twitter**: [@PhotoWalkHQ](https://twitter.com/photowalkhq)
- **Email**: support@photowalk.example

## ⚠️ Disclaimer

PhotoWalk is a community platform for photography enthusiasts. Photo walk participants are responsible for their own safety and should follow local laws and regulations. The platform does not provide insurance or liability coverage for events.

---

**Capture the moment, earn the reward 📸**
