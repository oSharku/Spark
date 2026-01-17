# Spark ⚡

<p align="center">
  <img src="https://img.shields.io/badge/Swift-5.0+-orange.svg" alt="Swift Version">
  <img src="https://img.shields.io/badge/Platform-iOS-blue.svg" alt="Platform">
  <img src="https://img.shields.io/badge/Status-60%25%20Complete-yellow.svg" alt="Development Status">
  <img src="https://img.shields.io/badge/License-MIT-green.svg" alt="License">
</p>

A modern iOS student productivity app designed to help students stay organized, manage assignments, track schedules, and earn rewards through gamification. Built with SwiftUI and following best practices in iOS development.

## 📱 About

Spark is a comprehensive productivity tool for students, combining assignment tracking, calendar management, class organization, and motivational gamification features into a single, elegant iOS application. Whether you're managing multiple classes, tracking deadlines, or staying connected with peers, Spark keeps you focused and productive.

## 🚀 Project Status

**Current Progress:** 60% Complete

This project is actively under development. Core features and architecture are in place, with ongoing work on additional features and refinements.

## 🛠 Tech Stack

- **Language:** Swift 5.0+
- **UI Framework:** SwiftUI
- **Architecture:** MVVM (Model-View-ViewModel)
- **Minimum iOS Version:** iOS 14.0+
- **Development Tool:** Xcode 12.0+

## ✨ Features

### 📚 Assignments Tracker
- Track all your assignments and homework in one place
- Monitor deadlines and due dates
- Mark assignments as complete
- Visual progress indicators

### 📅 Calendar
- View your entire schedule at a glance
- Schedule management for classes and events
- Daily, weekly, and monthly views
- Integrated with class schedules

### 🎓 Classes
- Organize and manage all your classes/subjects
- Store class details, schedules, and information
- Quick access to class-specific assignments
- Track class progress

### 🏆 Rewards (Gamification)
- Earn points for completing tasks
- Achievement system to stay motivated
- Unlock rewards and badges
- Track your productivity streak

### 💬 Chats
- Communicate with peers
- Study group coordination
- Class-based chat channels
- Real-time messaging

### ☰ Side Menu
- Quick navigation between modules
- User profile access
- Settings and preferences
- App information

## 🏗 Architecture

Spark follows the **MVVM (Model-View-ViewModel)** architectural pattern, ensuring a clean separation of concerns and maintainable codebase.

### Module Structure

```
Spark/
├── Views/
│   ├── Assignments/        # Assignment tracking interface
│   ├── Calendar/           # Schedule and calendar views
│   ├── Classes/            # Subject/class management
│   ├── Rewards/            # Gamification and achievement views
│   ├── Chats/              # Messaging interface
│   └── SideMenu/           # Navigation menu
│
├── Models/
│   ├── AppModels/          # Data models for the application
│   └── AppState/           # Centralized state management
│
└── Theme/                  # Custom styling and design system
    └── CustomStyles/       # Reusable UI components and themes
```

### Views Layer
The Views layer contains all SwiftUI view components organized by feature:

- **Assignments:** Interface for tracking and managing student assignments
- **Calendar:** Schedule visualization and event management
- **Classes:** Class/subject detail management and display
- **Rewards:** Gamification elements including achievements and progress
- **Chats:** Messaging and communication interface
- **SideMenu:** Navigation drawer for quick access to all features

### Models Layer
The Models layer handles data structure and state management:

- **AppModels:** Core data models representing assignments, classes, events, rewards, etc.
- **AppState:** Centralized state management using ObservableObject pattern for app-wide state

### Theme Layer
The Theme layer provides consistent styling across the application:

- **Custom Styling:** Reusable color schemes, fonts, spacing, and component styles
- **Design System:** Consistent visual language throughout the app

## 📋 Requirements

- iOS 14.0+
- Xcode 12.0+
- Swift 5.0+
- macOS 10.15+ (for development)

## 🚀 Getting Started

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/oSharku/Spark.git
   cd Spark
   ```

2. **Open in Xcode**
   ```bash
   open Spark.xcodeproj
   ```
   
   Or if using workspace:
   ```bash
   open Spark.xcworkspace
   ```

3. **Select your target device**
   - Choose a simulator or connected iOS device from the Xcode toolbar

4. **Build and Run**
   - Press `⌘ + R` or click the Run button in Xcode
   - The app will build and launch on your selected device

### Configuration

No additional configuration is required for the basic setup. The app is ready to run out of the box.

## 📸 Screenshots

_Screenshots coming soon as features are completed..._

## 🗺 Roadmap

- [ ] Complete remaining 40% of core features
- [ ] Implement data persistence (CoreData/SwiftData)
- [ ] Add cloud sync capabilities
- [ ] Implement push notifications for deadlines
- [ ] Add dark mode support
- [ ] Implement user authentication
- [ ] Add export/import functionality
- [ ] Create widget extensions
- [ ] App Store release

## 🤝 Contributing

Contributions are welcome! If you'd like to contribute to Spark, please follow these guidelines:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please ensure your code follows Swift best practices and includes appropriate documentation.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Sharku**

- GitHub: [@oSharku](https://github.com/oSharku)

## 🙏 Acknowledgments

- Built with Swift and SwiftUI
- Inspired by the need for better student productivity tools
- Thanks to the iOS development community

---

<p align="center">
  Made with ❤️ for students everywhere
</p>
