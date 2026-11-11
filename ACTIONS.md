# Exact Actions to Get Blood Ties Running as APK

## 1. Create GitHub Repository

1. Go to https://github.com/new
2. Repository name: `blood-ties-game` (or any name you like)
3. Set to **Public** or **Private**
4. **Do not** initialize with README (we already have one)
5. Click **Create repository**

## 2. Push the Project

On your computer (or in GitHub Codespaces / local terminal):

```bash
# Download / unzip the project folder first, then:
cd blood-ties-game

git init
git add .
git commit -m "Initial Blood Ties interactive narrative game"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/blood-ties-game.git
git push -u origin main
```

Replace `YOUR_USERNAME` with your actual GitHub username.

## 3. Enable GitHub Actions

- Go to your new repo on GitHub
- Click the **Actions** tab
- If prompted, click “I understand my workflows, go ahead and enable them”
- The workflow `Build Android APK` will appear

## 4. Trigger First Build

Option A – Automatic:
- Just push any small change (or the initial push already triggers it)

Option B – Manual:
- Actions → Build Android APK → **Run workflow** → Run

After a few minutes you will see an artifact named **BloodTies-debug-apk**.  
Download the `.apk` from the artifact.

## 5. Install Godot Locally (recommended for development)

1. Download Godot 4.3+ from https://godotengine.org
2. Open `project.godot`
3. Editor → Manage Export Templates → Download and Install
4. Project → Export → Add → Android
5. Set package name to `com.sikoka.bloodties` (or your own)
6. Export → Export Project → save as `.apk`

## 6. (Optional) Signed Release Builds

Later, when you want Play Store / proper signing:

1. Create a keystore:
   ```bash
   keytool -genkey -v -keystore bloodties.keystore -alias bloodties -keyalg RSA -keysize 2048 -validity 10000
   ```

2. Convert to base64:
   ```bash
   base64 -w 0 bloodties.keystore > keystore.b64
   ```

3. In GitHub → Settings → Secrets and variables → Actions → New repository secret:
   - `ANDROID_KEYSTORE_BASE64` → paste the base64 content
   - `ANDROID_KEYSTORE_PASSWORD`
   - `ANDROID_KEY_ALIAS` → bloodties
   - `ANDROID_KEY_PASSWORD`

4. Uncomment the release signing steps in `.github/workflows/build-android.yml`

## Next Development Steps

1. Expand `dialogue/teaser.json` and create `act1.json`, `family_home.json`, etc.
2. Add more scenes (family kitchen, construction office, docks, basement)
3. Implement simple combat for the warehouse ambush
4. Add background images / character portraits in `assets/`
5. Add the “Philly Requiem” style music cues

---

Family first. Always.
