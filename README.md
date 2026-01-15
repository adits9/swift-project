# PocketPad

A modern iOS student hub app built with SwiftUI for high school students. PocketPad provides a centralized platform for managing class schedules, viewing lunch menus, exploring extracurricular activities, contacting staff, and staying connected with school social media.

## Features

### 🔐 Authentication
- Local user registration and login
- Secure password hashing (SHA256)
- Session persistence
- Input validation with friendly error messages

### 📅 Class Schedule
- Create and manage personalized class schedules
- Support for multiple periods
- Edit and delete schedule entries
- Extensible design for A/B day rotation
- User-specific schedule storage

### 🍽️ Lunch Menu
- View daily lunch menus
- Browse menus by date with calendar picker
- Displays main dishes, sides, desserts, and vegetarian options
- Loaded from local JSON file (offline-first)

### ⭐ Extracurricular Activities
- Browse all school activities
- Search by name, description, or category
- Favorite/bookmark activities
- Detailed information: meeting times, locations, contact emails
- Category-based filtering

### 📧 Email Staff
- Staff directory with teachers, counselors, and administrators
- Search and filter by role
- One-tap email composition using iOS Mail
- Pre-filled email templates
- Graceful handling when Mail is not configured

### 📆 Calendar
- Quick date reference with local picker
- Link to full school calendar (opens in Safari)
- Important dates and events access

### 🔗 Social Media Links
- Instagram, Twitter, YouTube, Facebook links
- Opens in Safari View Controller
- Centralized social media hub

## Architecture

### MVVM Pattern
```
Views → ViewModels → Repositories → Database
```

- **Views**: SwiftUI views for UI presentation
- **ViewModels**: Business logic and state management (@MainActor)
- **Repositories**: Data access layer with CRUD operations
- **Database**: GRDB-based local persistence

### Project Structure
```
PocketPad/
├── PocketPadApp.swift          # App entry point
├── Core/
│   ├── AppState.swift          # Global app state
│   ├── Config.swift            # Configuration constants
│   └── RootView.swift          # Root navigation coordinator
├── Features/
│   ├── Authentication/
│   │   ├── Views/
│   │   └── ViewModels/
│   ├── Dashboard/
│   ├── Schedule/
│   ├── LunchMenu/
│   ├── Extracurriculars/
│   ├── Email/
│   ├── Calendar/
│   └── SocialLinks/
├── Data/
│   ├── Models/                 # Data models (GRDB FetchableRecord/PersistableRecord)
│   ├── Repositories/           # Data access layer
│   └── Database/
│       └── DatabaseManager.swift
├── UI/
│   └── Components/             # Reusable UI components
└── Resources/
    └── lunch_menu.json         # Seed data for lunch menu

PocketPadTests/
├── AuthenticationTests.swift
├── ScheduleTests.swift
└── LunchMenuTests.swift
```

## Technology Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Minimum iOS**: 16.0
- **Database**: GRDB.swift (SQLite wrapper)
- **Architecture**: MVVM with Repository pattern
- **Concurrency**: async/await
- **Testing**: XCTest

## Dependencies

- [GRDB.swift](https://github.com/groue/GRDB.swift) (6.24.0+) - SQLite database toolkit

## Database Schema

### Tables
- **users**: User accounts (id, username, email, passwordHash, fullName, createdAt)
- **schedule_entries**: Class schedules (id, userId, period, subject, room, teacher, dayType, createdAt)
- **lunch_menu_items**: Lunch menus (id, date, mainDish, sides, dessert, vegetarianOption)
- **extracurriculars**: Activities (id, name, description, meetingTime, location, contactEmail, category)
- **staff_directory**: Staff contacts (id, name, email, role, department, subjectTaught, phoneExtension)
- **user_favorites**: User bookmarks (id, userId, itemType, itemId, createdAt)

## Setup Instructions

### Prerequisites
- macOS 13.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

### Installation

1. **Clone the repository**
   ```bash
   cd /Users/aditsaxena/Documents/swift-training/swift-project
   ```

2. **Open in Xcode**
   ```bash
   open Package.swift
   ```
   
   Or create a new iOS App project in Xcode and add the source files.

3. **Install Dependencies**
   
   If using Swift Package Manager:
   - In Xcode: File → Add Package Dependencies
   - Add: `https://github.com/groue/GRDB.swift.git`
   - Version: 6.24.0 or later

4. **Build the project**
   - Select a simulator or device
   - Press Cmd+B to build

5. **Run the app**
   - Press Cmd+R to run

### Creating an Xcode Project (Alternative)

If you need to create a full Xcode project:

1. Open Xcode
2. File → New → Project
3. Select "iOS App"
4. Product Name: PocketPad
5. Interface: SwiftUI
6. Language: Swift
7. Click Create
8. Add GRDB dependency via SPM (File → Add Package Dependencies)
9. Copy all source files into the project maintaining the folder structure
10. Add `lunch_menu.json` to the project resources

## Running Tests

1. In Xcode, press Cmd+U to run all tests
2. Or select Product → Test from the menu
3. View test results in the Test Navigator (Cmd+6)

## Configuration

Edit [Config.swift](PocketPad/Core/Config.swift) to customize:
- School name
- Calendar URL
- Social media links
- Schedule periods

## Seed Data

The app includes seed data for:
- **Extracurriculars**: 6 sample activities (Robotics, Drama, Debate, etc.)
- **Staff Directory**: 6 staff members (teachers, counselors, administrators)
- **Lunch Menu**: 10 days of sample menus (loaded from JSON)

This data is automatically seeded on first launch.

## Usage

### First Time Setup
1. Launch the app
2. Sign up with username, email, and password
3. After signup, you'll be automatically logged in

### Creating a Schedule
1. From Dashboard, tap "Schedule"
2. Tap the "+" button
3. Select period, enter subject, room, and teacher
4. Save

### Viewing Lunch Menu
1. From Dashboard, tap "Lunch Menu"
2. Use the calendar to select any date
3. View the menu details for that day

### Exploring Activities
1. From Dashboard, tap "Activities"
2. Browse or search for activities
3. Tap star icon to favorite
4. Expand entries to see details

### Emailing Staff
1. From Dashboard, tap "Email Staff"
2. Search or filter by role
3. Tap on a staff member's email
4. Compose your message in iOS Mail

## Accessibility

The app includes accessibility labels for:
- All interactive buttons
- Form fields
- Navigation elements

VoiceOver and other assistive technologies are supported.

## Known Limitations

- Email feature requires iOS Mail app to be configured
- Lunch menu data is currently static (loaded from JSON)
- Social links and calendar URL are placeholder examples
- No backend server (all data is local)

## Future Enhancements

- [ ] Push notifications for schedule reminders
- [ ] Export schedule to iOS Calendar
- [ ] Dark mode refinements
- [ ] iPad-optimized layouts
- [ ] Cloud sync with backend server
- [ ] Real-time lunch menu updates
- [ ] Student-to-student messaging
- [ ] Homework/assignment tracking

## Migration from Python/Kivy

This is a complete rewrite of the original Python/Kivy app with the following improvements:
- Native iOS performance and look-and-feel
- Better integration with iOS ecosystem (Mail, Safari)
- Modern SwiftUI declarative syntax
- Type-safe database operations with GRDB
- Proper MVVM architecture for testability
- Local-first data persistence

## License

This project is for educational purposes.

## Support

For issues or questions, please contact the development team.

---

**Built with ❤️ for Jefferson High School students**
