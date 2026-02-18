# 🎵 Flute AI — Setup Guide
### For Varshil & Swarup

---

## What You Have
```
flute_ai/
├── lib/
│   ├── main.dart              ← App entry point + themes
│   ├── shell.dart             ← Bottom nav (3 tabs)
│   ├── pages/
│   │   ├── home_page.dart     ← Mic + 3 tool cards
│   │   ├── ai_training_page.dart  ← Camera + AI chat
│   │   └── about_page.dart    ← Founders + theme toggle
│   └── widgets/
│       ├── tool_card.dart     ← Reusable card component
│       ├── sheet_wrapper.dart ← Rounded modal with X button
│       ├── metronome_sheet.dart   ← BPM slider + beat pulse
│       ├── tuner_sheet.dart   ← Cents meter + emoji face
│       └── vibrato_sheet.dart ← Waveform + rate/width stats
├── pubspec.yaml               ← All packages listed
└── SETUP.md                   ← This file
```

---

## Step 1 — Install Flutter (if you haven't)
1. Go to **flutter.dev** → click "Get Started"
2. Download Flutter for Mac or Windows
3. Follow their install steps (takes ~15 min)
4. Run this in Terminal to confirm it works:
   ```
   flutter doctor
   ```

---

## Step 2 — Open the Project in Cursor
1. Download **Cursor** from cursor.com (free)
2. Open Cursor → File → Open Folder → pick your `flute_ai` folder
3. Open the built-in terminal: **View → Terminal**

---

## Step 3 — Add a Tick Sound File
The metronome needs a `tick.mp3` file.

1. Download any free tick/click sound from **freesound.org**
2. Rename it `tick.mp3`
3. Create a folder called `assets` inside your `flute_ai` folder
4. Drop `tick.mp3` inside `/assets/tick.mp3`

---

## Step 4 — Install All Packages
In the Cursor terminal, run:
```bash
flutter pub get
```

---

## Step 5 — Run on Your iPhone 14 Pro
1. Plug in your iPhone via USB
2. Trust the computer on your phone when prompted
3. In terminal run:
   ```bash
   flutter run
   ```
4. The app will build and launch on your phone! 🎉

---

## Step 6 — iOS Permissions (IMPORTANT)
Open `ios/Runner/Info.plist` and add these lines inside `<dict>`:

```xml
<key>NSMicrophoneUsageDescription</key>
<string>Flute AI needs the microphone to tune and analyze your playing.</string>

<key>NSCameraUsageDescription</key>
<string>Flute AI needs the camera to check your flute posture.</string>
```

Without this, Apple will reject the app.

---

## What Each Page Does

### 🏠 Home (middle tab)
- Tap **Enable Microphone** first — this unlocks all 3 tools
- Tap **Metronome** → a card slides up from the bottom
  - Drag the slider for BPM (50–1000)
  - Use your iPhone volume buttons for loudness
  - Hit Start — feel the beat AND haptic vibration!
- Tap **Tuner** → shows your note name, Hz, and a smiley that gets sadder as you go out of tune
- Tap **Vibrato Scanner** → shows a live waveform + your vibrato rate and width

### 🤖 AI Training (left tab)
- Camera shows your flute posture live
- Type any question in the chat box and get coaching tips

### ℹ️ About (right tab)
- Founder cards for Varshil and Swarup
- Light/Dark mode toggle at the bottom

---

## Adding Real Pitch Detection (Advanced)
The tuner currently simulates pitch. To make it real:

1. Add to pubspec.yaml:
   ```yaml
   pitch_detector_dart: ^0.0.6
   ```
2. Ask Cursor AI: *"Replace the simulated pitch in tuner_sheet.dart with real microphone input using pitch_detector_dart"*

---

## Need Help?
Just paste any error message into Cursor's AI chat and say:
> "Fix this error in my Flutter app"

Cursor will fix it for you! 🚀
