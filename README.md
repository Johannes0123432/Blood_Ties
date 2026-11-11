# Blood Ties – Interactive Narrative Game (Godot 4)

**Based on the screenplay by Johannes Sikoka**

A choice-driven narrative thriller set in South Philly.  
Play as Jackie Moretti. Make decisions that affect family, loyalty, and survival.  
"Family first" is not just a motto — it's the only rule that matters… until it isn't.

## Features (Starter)

- Full teaser + Act 1 structure from the screenplay
- Branching dialogue and moral choices
- Simple investigation / combat encounters (expandable)
- Save system
- Atmospheric South Philly setting
- Designed for Android (APK) and desktop

## Requirements

- **Godot 4.3+** (recommended 4.3 or 4.4)
- Android export templates (download inside Godot: Editor → Manage Export Templates)
- For APK signing: your own keystore (or debug for testing)

## Quick Start

1. Clone this repository
2. Open the project in Godot 4 (`project.godot`)
3. Press **F5** to run
4. To export APK:
   - Project → Export → Add → Android
   - Set package name: `com.yourname.bloodties`
   - Configure keystore (or use debug)
   - Export Project → Save as `.apk`

## GitHub Actions – Automatic APK Builds

This repo includes a GitHub Actions workflow that builds a debug APK on every push to `main` and on tags.

### Setup Steps (do these once)

1. Create a new GitHub repository (public or private)
2. Push this entire folder to it:
   ```bash
   git init
   git add .
   git commit -m "Initial Blood Ties game project"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/blood-ties-game.git
   git push -u origin main
   ```

3. (Optional but recommended) Add secrets for release signing:
   - Go to repo → Settings → Secrets and variables → Actions
   - Create secrets:
     - `ANDROID_KEYSTORE_BASE64` (base64 of your .jks/.keystore file)
     - `ANDROID_KEYSTORE_PASSWORD`
     - `ANDROID_KEY_ALIAS`
     - `ANDROID_KEY_PASSWORD`

4. The workflow will automatically:
   - Build a **debug APK** on every push
   - Build a **signed release APK** when you create a tag (`v1.0.0` etc.)
   - Upload the APK as an artifact / release asset

### Manual trigger
Go to Actions tab → "Build Android APK" → Run workflow

## Project Structure

```
blood-ties-game/
├── project.godot
├── scenes/
│   ├── main_menu.tscn
│   ├── dialogue_scene.tscn
│   ├── warehouse_opening.tscn
│   └── ...
├── scripts/
│   ├── dialogue_manager.gd
│   ├── game_state.gd
│   ├── choice_button.gd
│   └── ...
├── dialogue/
│   ├── teaser.json
│   ├── act1.json
│   └── ...
├── assets/
├── .github/workflows/build-android.yml
└── README.md
```

## Expanding the Game

- Add more dialogue JSON files following the screenplay structure
- Create new scenes for docks, basement, family home, FBI office
- Implement simple turn-based or real-time combat for the warehouse ambush and docks
- Add inventory (guns, cash, ledgers, photos)
- Track "Family First" reputation / trust meters for Maria, Luca, Frankie, Vito

## Credits

Screenplay: Johannes Sikoka  
Game adaptation starter: generated for the author

---

**Family first. Always.**
