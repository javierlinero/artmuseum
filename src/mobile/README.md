# PUAM Mobile Application

## Setting up Flutter

To set up Flutter, please refer to the original Flutter documentation seen here: [https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install).

## Flutter in Visual Studio Code
Please install the Flutter and Dart extensions for VSCode, and my preferred additional extensions are `Flutter Widget Snippets` by Alexis Villegas Torres and `flutter-stylizer` by gmlewis-vscode.


## Setting up Android Emulator
### Android Studio
Please refer to the Android Studio install guide here: [https://developer.android.com/studio](https://developer.android.com/studio).

Start Android Studio and go through the 'Android Studio Setup Wizard'. This installs the latest Android SDK, Android SDK Command-Line Tools, and Android SDK Build-Tools.
### Creating the Device
1. Start Android Studio.
2. Go to `Tools > Device Manager`
3. Click `Create Device`
4. Choose a device to emulate, and click `Next`.
5. Choose an API, then click `Next`.
6. Name the device if needed, then click `Finish`.

### Start the Emulator
In the bottom right, you should see the currently selected device, which will either be some web platform or your current operating system, i.e., Windows or Apple Mac. Click that to bring up the device menu.

You should see your recently created device in the list. Click it, and verify that it is selected in the bottom right.

### Run the App!
With the emulator open, make sure it is finished launching, and then you can go open the `lib\main.dart` file and in the top right, click the run button. That, or click `F5`, or go to the menu at the top of VSCode, and go to `Run > Start Debugging`.

## iOS Emulation
I have no way of verifying this for myself right now, but I believe all you need to do is download XCode, and go to `Xcode > Open Developer Tool > Simulator`, and set up the simulator there. From there, the process is similar and you need to select the device in VSCode.