### 1.0.0
- Added option to change roulette field color
- Added option to use custom colors for roulette fields
- Added option to move roulette fields to a different slot
- Added saving custom roulettes for later use
- Added toast popup showing text of the winner field 
- Added localization support
- Changed the default language to english
- Added polish translation
- Added built-in update checker
- Changed main view button arrangment
- Improved about dialog look
- Limited maximum size of the roulette on bigger displays
- Improved text rendering inside the roulette, especially when many fields are present
- Fixed some components not using Material You dynamic colors
- Fixed Windows InnoSetup installer build missing dynamic_color_plugin.dll

### 0.6.0
- Updated the Flutter SDK to version 3.47.1
- Updated remaining dependencies
- Added Material You / dynamic color support
- Added light, dark, and system theme mode switching in the app menu
- Made the center blue circle the spin button and removed the floating action button
- Limited the number of roulette fields to 30
- Changed versioning schema for web-based version
- Migrated the Android build to the Built-in Kotlin Gradle Plugin
- Fixed a color overflow crash when the number of fields exceeded the available colors
- Improved CI/CD processes
- Cleaned up project

### 0.5.0
- Updated the Flutter SDK to version 3.38.10
- Updated the Dart SDK to version 3.10.9
- Updated remaining dependencies
- Updated the UI to Material Design 3
- Raised the minimum required Android API level to 24 (Android 7.0 Nougat)
- Added installation via .deb packages
- Added installation via RPM packages
- Added installation via Pacman package manager
- Added installation via Flatpak package
- Added a Windows installer

### 0.4.0
 - Added undo button
 - Modified buttons style
 - Hidden roulette's rotation direction option
 - Changed minimum roulette fields shown to 2
 - Changed arrow color
 - Changed FAB icon to "play_arrow" (#9 - Karol Stawowski)
 - Updated "roulette" package to version 0.1.3+1

### 0.3.0
 - Added automatic focus on TextField after adding new roulette field
 - Added submiting new fields with Return (Enter) key
 - Rearranged UI to better suit mobile users
 - Changed UI colors
 - Made roulette colors more vibrant
 - Fixed arrow being visibly behind the roulette
 - (Web)(Windows) Added app icon
 - (Web) Fixed wrong font colors for roulette fields
 - Bumped up Flutter SDK
 - Bumped up Dart SDK

### 0.2.0
 - Added button to clear roulette
 - Added text size limit
 - Clearing TextInput after new item adding
 - (Windows)(Linux) Set min window size
 - (Android) Change app icon

### 0.1.0
 - Adjusted app name for all platforms
 - Increased limit of possible roulette fields
 - Fixed a bug in the RNG
 - Added AlertBox informing about reaching the limit
 - Font size adjustement in roulette fields
