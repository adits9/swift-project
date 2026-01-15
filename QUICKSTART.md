# PocketPad - Quick Start Guide

## Option 1: Using Xcode (Recommended)

### Step 1: Create New Xcode Project
1. Open Xcode
2. File → New → Project
3. Select **iOS App** template
4. Configure:
   - Product Name: **PocketPad**
   - Team: (your team)
   - Organization Identifier: com.yourname
   - Interface: **SwiftUI**
   - Language: **Swift**
   - Storage: None (we'll use GRDB)
5. Click **Create**

### Step 2: Add GRDB Dependency
1. In Xcode, select your project in the navigator
2. Select the **PocketPad** target
3. Go to **Package Dependencies** tab
4. Click **+** button
5. Enter: `https://github.com/groue/GRDB.swift.git`
6. Click **Add Package**
7. Select version **6.24.0** or later
8. Click **Add Package** again

### Step 3: Import Source Files
1. Delete the default `ContentView.swift` file
2. Create folder structure in your project:
   ```
   PocketPad/
   ├── PocketPadApp.swift (replace default)
   ├── Core/
   ├── Features/
   ├── Data/
   ├── UI/
   ├── Utilities/
   └── Resources/
   ```
3. Copy all `.swift` files from this repository into the corresponding folders
4. Make sure to select "Copy items if needed" and add to target

### Step 4: Add Resources
1. Drag `lunch_menu.json` into the Resources folder
2. Ensure it's added to the app target (check Target Membership)

### Step 5: Configure Info.plist
1. Select `Info.plist` in your project
2. Verify or add required keys (already in the provided Info.plist)

### Step 6: Build and Run
1. Select a simulator (iPhone 14 or later recommended)
2. Press **Cmd+B** to build
3. Press **Cmd+R** to run
4. Sign up with a new account to start using the app!

---

## Option 2: Using Swift Package (Advanced)

If you prefer working with Swift Package Manager:

1. Open Terminal and navigate to the project directory:
   ```bash
   cd /Users/aditsaxena/Documents/swift-training/swift-project
   ```

2. Open the Package.swift:
   ```bash
   open Package.swift
   ```

3. Build:
   ```bash
   swift build
   ```

4. Test:
   ```bash
   swift test
   ```

Note: To run the actual iOS app, you'll still need to create an Xcode project and import the code.

---

## Common Issues & Solutions

### Issue: GRDB not found
**Solution**: Make sure you've added the GRDB package dependency and it has finished downloading.

### Issue: Build errors about missing modules
**Solution**: Clean build folder (Cmd+Shift+K) and rebuild (Cmd+B).

### Issue: Database errors on first launch
**Solution**: Delete the app from simulator and reinstall. The database will be created fresh.

### Issue: Email feature doesn't work
**Solution**: Configure Mail app in the iOS Simulator or use a real device with Mail configured.

### Issue: lunch_menu.json not found
**Solution**: Verify the JSON file is in the Resources folder and is added to the app target.

---

## Running Tests

1. Press **Cmd+U** to run all tests
2. Or Product → Test from menu
3. View results in Test Navigator (Cmd+6)

Tests cover:
- ✅ User authentication (signup/login)
- ✅ Schedule CRUD operations
- ✅ Lunch menu date lookups

---

## Project Structure Overview

```
PocketPad/
├── PocketPadApp.swift              # App entry point
├── Core/
│   ├── AppState.swift              # Global state management
│   ├── Config.swift                # App configuration
│   └── RootView.swift              # Root navigation
├── Features/                       # Feature modules
│   ├── Authentication/
│   ├── Dashboard/
│   ├── Schedule/
│   ├── LunchMenu/
│   ├── Extracurriculars/
│   ├── Email/
│   ├── Calendar/
│   └── SocialLinks/
├── Data/
│   ├── Models/                     # Data models
│   ├── Repositories/               # Data access layer
│   └── Database/                   # DB management
├── UI/
│   └── Components/                 # Reusable components
├── Utilities/
│   └── Extensions.swift
└── Resources/
    └── lunch_menu.json

PocketPadTests/                     # Unit tests
```

---

## Next Steps

After successfully running the app:

1. **Sign Up**: Create a test account
2. **Create Schedule**: Add your classes
3. **Explore Features**: Try all dashboard tiles
4. **Customize**: Edit Config.swift with your school's information
5. **Extend**: Add new features or modify existing ones

---

## Need Help?

- Check the main README.md for detailed documentation
- Review the inline code comments
- Examine the test files for usage examples

**Happy coding! 🚀**
