# GitApp

GitApp is an interactive educational iOS application built with SwiftUI, designed to teach users the basics of Git through a visually engaging and hands-on experience. The app simulates a Git workflow, allowing users to learn and practice commands in a playful environment.

## Features

- **Onboarding Flow:** Guides users through entering their name, project name, and custom file names.
- **Interactive Terminal:** Simulates Git commands (`git init`, `git branch`, `git checkout`, `git status`, `git add`, `git commit`, `git push`) with visual feedback and command history.
- **Visual Effects:** Includes animated backgrounds, snowfall, and dynamic UI elements to enhance engagement.
- **Photo Studio Simulation:** Visualizes file staging, committing, and pushing with custom graphics and transitions.
- **User Personalization:** User and project names are reflected throughout the app.
- **Educational Graphics:** Uses custom images and icons to illustrate Git concepts.

## App Structure

- **App Entry:**
  - `App/MyApp.swift`: Main entry point, launches `NewContentView`.
  - `App/NewContentView.swift`: Splash screen and transition to onboarding.
- **Views:**
  - `VIews/OnboardingView.swift`: Step-by-step onboarding for user and project info.
  - `VIews/UserInfoVIew.swift`: Collects user and project details, then navigates to the main experience.
  - `VIews/LandingPageView.swift`: Main interactive area with terminal and visual feedback.
  - `VIews/PhotoStudioView.swift`: Simulates file staging, committing, and pushing.
- **SubViews:**
  - `SubViews/TerminalView.swift`: Handles command input, output, and history.
  - `SubViews/CircleView.swift`, `PromptView.swift`, `SnowfallView.swift`, `UserInfoCardView.swift`: UI components for effects and user info.
- **Models:**
  - `Models/SharedData.swift`: ObservableObject for sharing user/project state and command history.
- **Assets:**
  - Custom images and icons for Git concepts, backgrounds, and UI elements.

## Getting Started

### Requirements
- Xcode 15+
- iOS 16.0+
- Swift 6

### Installation
1. Clone the repository:
   ```sh
   git clone <repo-url>
   ```
2. Open `GitApp.swiftpm` in Xcode.
3. Build and run on a simulator or device.

## Usage
- Launch the app and follow the onboarding steps.
- Enter your name, project name, and file names.
- Use the interactive terminal to execute Git commands and watch the visual feedback.
- Progress through the Git workflow: init, branch, checkout, status, add, commit, and push.

## Project Structure
```
GitApp.swiftpm/
  ├── App/
  ├── Assets.xcassets/
  ├── Models/
  ├── SubViews/
  └── VIews/
```

## License
This project is for educational purposes.

---

*Created by Shahma Ansari* 