# Aviate

Learn aviation through short, gamified lessons. The more you learn, the bigger your plane gets.

Native iPhone app: **iOS 26+, SwiftUI, Swift 6, Observation, SwiftData, Liquid Glass.**

## Requirements

- macOS with **Xcode 26** or later
- [XcodeGen](https://github.com/yonaskolb/XcodeGen): `brew install xcodegen`

## Getting started

```bash
xcodegen generate      # creates Aviate.xcodeproj from project.yml
open Aviate.xcodeproj
```

Pick an iOS 26 simulator and run the **Aviate** scheme. Tests: `⌘U`.

The `.xcodeproj` is generated and git-ignored. Change targets, settings and capabilities in
`project.yml`, then run `xcodegen generate` again.

## Free: sideload from Windows

No Mac and no paid Apple account. GitHub Actions builds an unsigned `.ipa`, and
[Sideloadly](https://sideloadly.io) signs it with your free Apple ID and installs it over USB.

**1. Put the code on GitHub.** Install [Git for Windows](https://git-scm.com/download/win), create an
empty repo on GitHub, then run in this folder:
```bash
git init -b main
git add .
git commit -m "Aviate skeleton"
git remote add origin https://github.com/<you>/aviate.git
git push -u origin main
```
A **public** repo gets unlimited free macOS build minutes. A **private** repo gets 2,000 free
minutes a month, but macOS minutes count 10×, which works out to about 20 builds.

**2. Download the build.** Every push runs **Build unsigned IPA** (repo → Actions tab). It takes
about 10–15 minutes. Open the finished run and download **Aviate-unsigned-ipa** under Artifacts,
then unzip it to get `Aviate-unsigned.ipa`. If the run fails, copy the log of the step that failed.

**3. Install Sideloadly on Windows.** Sideloadly needs the **web-download** (non-Microsoft Store)
versions of [iTunes](https://www.apple.com/itunes/download/win64) and
[iCloud](https://support.apple.com/en-us/103232) to talk to the iPhone. Then install
[Sideloadly](https://sideloadly.io).

**4. Sideload.**
- Connect the iPhone by USB, unlock it, and tap **Trust**.
- In Sideloadly, drag in the `.ipa`, enter your Apple ID, and click **Start**.
  You can use a secondary Apple ID if you prefer.

**5. Allow the app on the iPhone (first time only).**
- Settings → Privacy & Security → **Developer Mode** → On. The phone restarts.
- Settings → General → **VPN & Device Management** → your Apple ID → **Trust**.

**Limits of a free Apple ID:**
- The app stops opening after **7 days**. Re-sideload it (no data is lost), or turn on Sideloadly's
  auto-refresh, which re-signs over Wi-Fi while the PC is on.
- At most 3 sideloaded apps at a time.
- **Sign in with Apple** and **push notifications** need the paid program. Google sign-in,
  widgets and local Live Activities can still be tested.

## Paid: TestFlight via Codemagic ($99/year Apple Developer Program)

No Mac needed: [Codemagic](https://codemagic.io) builds the app on a cloud Mac and uploads it
to TestFlight, and you install it from the TestFlight app. Every push to `main` produces a new build.

You do the setup below once, all in a browser.

**1. Join the Apple Developer Program** ($99/year) at
[developer.apple.com/programs/enroll](https://developer.apple.com/programs/enroll), or use the
Apple Developer app on your iPhone. Approval can take up to 48 hours.

**2. Choose a bundle ID.** For example `com.yourname.aviate`. Replace `com.CHANGE-ME.aviate`
with it in **three places**: `project.yml` (two places) and `codemagic.yaml`.

**3. Register the bundle ID.** In [Certificates, IDs & Profiles](https://developer.apple.com/account/resources/identifiers/list),
go to Identifiers → **+** → App IDs → App. Choose an Explicit bundle ID and enter the ID from step 2.

**4. Create the app record.** In [App Store Connect](https://appstoreconnect.apple.com), go to
Apps → **+** → New App. Choose iOS, name it "Aviate" (if the name is taken, try "Aviate: Learn to Fly"),
pick your bundle ID, and use `aviate` as the SKU.

**5. Create an API key.** In App Store Connect, go to Users and Access → Integrations →
App Store Connect API → Team Keys → **+**.
- Set access to **App Manager**.
- Download the `.p8` file. You can only download it once.
- Note the **Key ID** and **Issuer ID**.

**6. Push the code to GitHub.** Install [Git for Windows](https://git-scm.com/download/win) and
create an empty **private** repo on GitHub. Then, in this folder:
```bash
git init -b main
git add .
git commit -m "Aviate skeleton"
git remote add origin https://github.com/<you>/aviate.git
git push -u origin main
```

**7. Set up Codemagic.** Sign up at [codemagic.io](https://codemagic.io) with GitHub, then:
- **Add the API key.** Go to Team settings → Team integrations → Developer Portal → Manage keys → Add key.
  Name it exactly **`Aviate ASC Key`**, then enter the Issuer ID and Key ID and upload the `.p8`.
- **Create the distribution certificate.** Go to Team settings → codemagic.yaml settings →
  Code signing identities → iOS certificates → **Generate certificate** → Apple Distribution.
- **Create and fetch the provisioning profile.** Back in Certificates, IDs & Profiles, go to
  Profiles → **+** → App Store Connect. Pick your App ID and the certificate Codemagic just made.
  Then, in Codemagic, go to iOS provisioning profiles → **Fetch profiles** and select that profile.
- **Add the app.** Go to Applications → Add application → GitHub → your repo, and choose the
  `codemagic.yaml` configuration.

**8. Build.** Click **Start new build** and pick the `ios-testflight` workflow. A build takes about
15–20 minutes. If it fails, copy the log of the step that failed.

**9. Install on your iPhone.** In App Store Connect, open your app → TestFlight → Internal Testing →
**+** to create a group, then add yourself. Install **TestFlight** from the App Store on your iPhone,
accept the invite, and tap Install. Apple usually takes 5–15 minutes to process a build
before it shows up.

## Running on a Mac

If you have access to a Mac, see [Getting started](#getting-started): `xcodegen generate`,
then ⌘R in Xcode.

## Project structure

```
Aviate/
├── App/                 Entry point, router, tab bar (RootView), shared screen shells
├── DesignSystem/
│   ├── Theme/           Palette, Typography (Dynamic-Type-scaled), Metrics
│   ├── Haptics/         HapticsService: taps + CoreHaptics touchdown / error / level-up
│   ├── Components/      TopBar, GlassSegmentedControl, SearchCapsule, GroupedCard,
│   │                    IconToggleCapsule, SectionHeader, StatRow, button styles
│   ├── Sheet/           MapSheetScaffold: draggable dark sheet over a map
│   └── Map/             MapBackground (dark MapKit backdrop), HomeBase
├── Features/            One folder per module: Learn, Lesson, Hangar, Inbox, Atlas, Search, Profile
└── Resources/           Assets, Localizable.xcstrings
AviateTests/             Swift Testing unit tests
```

**Architecture:** MVVM with `@Observable` view models, one folder per feature, and dependencies
injected through the SwiftUI environment (`AppRouter` via `.environment(_:)`, services via
`EnvironmentValues` entries such as `\.haptics`).

## Design system at a glance

| Token | Value |
|---|---|
| Sheet background | `#1E1F24` |
| Card surface | `#2A2B30` |
| Divider | `#3A3B40` |
| Accent | `#3B82F6` |
| Success / Warning / Error | `#34C759` / `#FF9F0A` / `#FF453A` |
| XP gold | `#FFD60A` |
| Sheet / card radius | 38pt / 28pt |

Every screen has a `#Preview`. Use `.previewEnvironment()` to inject dependencies.

## Setup for later steps

These sections are filled in as each step lands:

- **Sign in with Apple:** capability + entitlement *(step 2)*
- **Google Sign-In:** client ID and URL scheme *(step 2)*
- **Backend:** Firebase project, `GoogleService-Info.plist` *(step 2)*
- **App Groups:** shared container for widgets and Live Activities *(step 7)*

## Roadmap

1. ✅ Project skeleton + design system
2. Auth (Apple + Google) and cloud sync
3. Onboarding questionnaire + personalized path
4. Lesson engine (10 exercise types) + content
5. Gamification (XP, ranks, streaks, fuel, coins, leagues, quests)
6. Hangar (3D aircraft, upgrades, liveries)
7. Live Activities, Dynamic Island, widgets, App Intents
