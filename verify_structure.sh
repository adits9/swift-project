#!/bin/bash

# PocketPad - Xcode Project Setup Script
# This script helps verify the project structure

echo "🔍 PocketPad Project Structure Verification"
echo "==========================================="
echo ""

# Check if we're in the right directory
if [ ! -f "README.md" ]; then
    echo "❌ Error: Please run this script from the project root directory"
    exit 1
fi

echo "✅ Running from project root"
echo ""

# Count Swift files
SWIFT_FILES=$(find PocketPad -name "*.swift" 2>/dev/null | wc -l | tr -d ' ')
echo "📝 Swift files found: $SWIFT_FILES"

# Count test files
TEST_FILES=$(find PocketPadTests -name "*.swift" 2>/dev/null | wc -l | tr -d ' ')
echo "🧪 Test files found: $TEST_FILES"

# Check for important files
echo ""
echo "📋 Checking key files:"

check_file() {
    if [ -f "$1" ]; then
        echo "  ✅ $1"
    else
        echo "  ❌ $1 (missing)"
    fi
}

check_file "PocketPad/PocketPadApp.swift"
check_file "PocketPad/Core/AppState.swift"
check_file "PocketPad/Core/Config.swift"
check_file "PocketPad/Data/Database/DatabaseManager.swift"
check_file "PocketPad/Resources/lunch_menu.json"
check_file "Package.swift"
check_file "README.md"
check_file "QUICKSTART.md"

echo ""
echo "📂 Project Structure:"
echo "================================"

# Display directory tree (limited depth)
if command -v tree &> /dev/null; then
    tree -L 3 -I 'build|DerivedData|.build|.swiftpm' PocketPad
else
    echo "  (Install 'tree' command for better visualization)"
    find PocketPad -type d -maxdepth 3 | sed 's|[^/]*/| |g'
fi

echo ""
echo "================================"
echo "✅ Verification complete!"
echo ""
echo "Next steps:"
echo "1. Open Xcode and create a new iOS App project named 'PocketPad'"
echo "2. Add GRDB.swift package dependency (https://github.com/groue/GRDB.swift.git)"
echo "3. Copy all source files into your Xcode project"
echo "4. Add lunch_menu.json to Resources"
echo "5. Build and run!"
echo ""
echo "See QUICKSTART.md for detailed instructions."
