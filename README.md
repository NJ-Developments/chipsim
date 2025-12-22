# 🎰 Chip Simulator

A digital chip tracker for poker and blackjack. Use real cards IRL - this app handles the chips and enforces betting rules.

![Version](https://img.shields.io/badge/version-2.1-green)
![License](https://img.shields.io/badge/license-MIT-blue)

## 🎮 Features

### Texas Hold'em Poker
- 2-8 player support
- Automatic blind posting
- Strict betting rules enforcement
- Burn card prompts
- Series statistics tracking
- Undo functionality

### Blackjack
- Single player with optional 2-hand mode
- Multiplayer mode (2-7 players)
- Split up to 4 hands
- Double down & surrender
- Insurance bets
- Streak tracking
- Leaderboard & highscores

## 🚀 Live Demo

Visit the live app: [Chip Simulator](https://chip-simulator.web.app)

## 📱 Installation

### Web (PWA)
1. Visit the app URL in your browser
2. Click "Add to Home Screen" to install as an app

### Mobile (Capacitor)
See [MOBILE_DEPLOYMENT.md](MOBILE_DEPLOYMENT.md) for iOS and Android build instructions.

## 🛠️ Development

### Prerequisites
- Node.js v18+
- npm

### Setup
```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/chipsim.git
cd chipsim

# Install dependencies
npm install

# Start local server (optional)
npx serve .
```

### Firebase Setup
1. Create a project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Anonymous Authentication
3. Set up Realtime Database
4. Update `firebase-config.js` with your credentials

### Deploy to Firebase Hosting
```bash
npm install -g firebase-tools
firebase login
firebase deploy
```

## 📁 Project Structure

```
chipsim/
├── index.html          # Home screen
├── blackjack.html      # Blackjack game
├── poker.html          # Poker game
├── script.js           # Blackjack logic
├── poker.js            # Poker logic
├── cloud-storage.js    # Firebase sync
├── firebase-config.js  # Firebase setup
├── style.css           # All styles
├── manifest.json       # PWA manifest
└── database.rules.json # Firebase security rules
```

## ⚠️ Disclaimer

**For Entertainment Purposes Only**

This app simulates casino chip tracking and does not involve real money gambling. No actual currency is wagered, won, or lost. Success in this game does not indicate future success in real money gambling.

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📞 Support

- [Capacitor Docs](https://capacitorjs.com/docs)
- [Firebase Docs](https://firebase.google.com/docs)
