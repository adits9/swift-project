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

## Technology Stack

- **Language**: Swift 5.9+
- **UI Framework**: SwiftUI
- **Minimum iOS**: 16.0
- **Database**: GRDB.swift (SQLite wrapper)
- **Architecture**: MVVM with Repository pattern
- **Concurrency**: async/await
- **Testing**: XCTest

## Database Schema

### Tables
- **users**: User accounts (id, username, email, passwordHash, fullName, createdAt)
- **schedule_entries**: Class schedules (id, userId, period, subject, room, teacher, dayType, createdAt)
- **lunch_menu_items**: Lunch menus (id, date, mainDish, sides, dessert, vegetarianOption)
- **extracurriculars**: Activities (id, name, description, meetingTime, location, contactEmail, category)
- **staff_directory**: Staff contacts (id, name, email, role, department, subjectTaught, phoneExtension)
- **user_favorites**: User bookmarks (id, userId, itemType, itemId, createdAt)

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


## Future Enhancements

- [ ] Push notifications for schedule reminders
- [ ] Dark mode refinements
- [ ] iPad-optimized layouts
- [ ] Student-to-student messaging
