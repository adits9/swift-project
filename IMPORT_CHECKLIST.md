# PocketPad - File Import Checklist for Xcode

When importing files into your Xcode project, use this checklist to ensure everything is added correctly.

## ✅ Import Checklist

### Step 1: Create Folder Groups in Xcode

Right-click on the PocketPad folder in Xcode and create these groups:

- [ ] Core
- [ ] Features
  - [ ] Authentication
    - [ ] Views
    - [ ] ViewModels
  - [ ] Dashboard
  - [ ] Schedule
    - [ ] Views
    - [ ] ViewModels
  - [ ] LunchMenu
    - [ ] Views
    - [ ] ViewModels
  - [ ] Extracurriculars
    - [ ] Views
    - [ ] ViewModels
  - [ ] Email
    - [ ] Views
    - [ ] ViewModels
  - [ ] Calendar
  - [ ] SocialLinks
- [ ] Data
  - [ ] Models
  - [ ] Repositories
  - [ ] Database
- [ ] UI
  - [ ] Components
- [ ] Utilities
- [ ] Resources

### Step 2: Import Files (Check Target Membership)

**Important**: When dragging files, ensure "Copy items if needed" is checked and "PocketPad" target is selected.

#### Root Level (1 file)
- [ ] PocketPadApp.swift

#### Core (3 files)
- [ ] AppState.swift
- [ ] Config.swift
- [ ] RootView.swift

#### Features/Authentication (5 files)
Views:
- [ ] AuthenticationView.swift
- [ ] LoginView.swift
- [ ] SignUpView.swift

ViewModels:
- [ ] LoginViewModel.swift
- [ ] SignUpViewModel.swift

#### Features/Dashboard (1 file)
- [ ] DashboardView.swift

#### Features/Schedule (4 files)
Views:
- [ ] ScheduleView.swift
- [ ] CreateScheduleView.swift
- [ ] EditScheduleView.swift

ViewModels:
- [ ] ScheduleViewModel.swift

#### Features/LunchMenu (2 files)
Views:
- [ ] LunchMenuView.swift

ViewModels:
- [ ] LunchMenuViewModel.swift

#### Features/Extracurriculars (2 files)
Views:
- [ ] ExtracurricularsView.swift

ViewModels:
- [ ] ExtracurricularsViewModel.swift

#### Features/Email (3 files)
Views:
- [ ] EmailStaffView.swift
- [ ] MailComposeView.swift

ViewModels:
- [ ] EmailStaffViewModel.swift

#### Features/Calendar (1 file)
- [ ] CalendarView.swift

#### Features/SocialLinks (1 file)
- [ ] SocialLinksView.swift

#### Data/Models (6 files)
- [ ] User.swift
- [ ] ScheduleEntry.swift
- [ ] LunchMenuItem.swift
- [ ] Extracurricular.swift
- [ ] StaffDirectoryEntry.swift
- [ ] UserFavorite.swift

#### Data/Repositories (5 files)
- [ ] UserRepository.swift
- [ ] ScheduleRepository.swift
- [ ] LunchMenuRepository.swift
- [ ] ExtracurricularRepository.swift
- [ ] StaffDirectoryRepository.swift

#### Data/Database (1 file)
- [ ] DatabaseManager.swift

#### UI/Components (1 file)
- [ ] DashboardTile.swift

#### Utilities (1 file)
- [ ] Extensions.swift

#### Resources (1 file)
- [ ] lunch_menu.json ⚠️ **Must be in app bundle, check Target Membership!**

### Step 3: Test Files (3 files)

Create PocketPadTests target and add:
- [ ] AuthenticationTests.swift
- [ ] ScheduleTests.swift
- [ ] LunchMenuTests.swift

### Step 4: Verify Target Membership

For each file, verify:
1. File Inspector (right panel) shows "Target Membership"
2. "PocketPad" is checked for app files
3. "PocketPadTests" is checked for test files
4. "lunch_menu.json" has "PocketPad" checked (not just folder reference)

### Step 5: Build Settings

Verify in project settings:
- [ ] Deployment Target: iOS 16.0 or later
- [ ] Swift Language Version: Swift 5
- [ ] Info.plist file is set correctly

### Step 6: Capabilities

No special capabilities needed, but verify:
- [ ] App Sandbox: Off (default for iOS)
- [ ] Background Modes: Not required

### Step 7: Build and Test

- [ ] Clean Build Folder (Cmd+Shift+K)
- [ ] Build (Cmd+B) - should succeed
- [ ] Run Tests (Cmd+U) - should pass
- [ ] Run App (Cmd+R) - should launch

## Common Issues

### Issue: "Cannot find 'GRDB' in scope"
**Solution**: Make sure GRDB package is added (File → Add Package Dependencies)

### Issue: "lunch_menu.json not found"
**Solution**: Select the file, check Target Membership in File Inspector, ensure PocketPad is checked

### Issue: "Module 'PocketPad' not found" in tests
**Solution**: Ensure test files have PocketPadTests target checked, not PocketPad

### Issue: Build errors about missing files
**Solution**: Verify all files are added to the project navigator (left panel)

## File Count Verification

Total files to import:
- **App Files**: 37 Swift files + 1 JSON file
- **Test Files**: 3 Swift files
- **Total**: 41 files

Run this to verify:
```bash
find PocketPad -name "*.swift" | wc -l     # Should show 37
find PocketPadTests -name "*.swift" | wc -l # Should show 3
```

## Next Steps After Import

1. [ ] Build succeeds without errors
2. [ ] All tests pass (Cmd+U)
3. [ ] App runs on simulator
4. [ ] Sign up works
5. [ ] Can create schedule
6. [ ] All features accessible from dashboard

## Ready? Let's Go! 🚀

Once all checkboxes are marked, your PocketPad app is ready to run!
