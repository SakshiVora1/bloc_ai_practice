# Flutter Project Setup Guide

## 1. Install Packages

Add the following packages in `pubspec.yaml`:

- flutter pub add flutter_bloc
- flutter pub add flutter_sound
- flutter pub add permission_handler
- flutter pub add flutter_svg
- flutter pub add record
- flutter pub add flutter_dotenv

---

## 2. Download Fonts

Download the **Poppins** font with the following weights:

- Light
- Regular
- Medium
- Bold

---

## 3. Create Asset Folders

Inside your project root folder, create an **assets** directory.

Structure:

assets/
├── images/
├── lottie/
└── fonts/

---

## 4. Update pubspec.yaml

Add the asset paths in `pubspec.yaml`.

Example:

```yaml
flutter:
  assets:
    - assets/images/
    - assets/lottie/

  fonts:
    - family: Poppins
      fonts:
        - asset: assets/fonts/Poppins-Light.ttf
          weight: 300
        - asset: assets/fonts/Poppins-Regular.ttf
          weight: 400
        - asset: assets/fonts/Poppins-Medium.ttf
          weight: 500
        - asset: assets/fonts/Poppins-Bold.ttf
          weight: 700
```

---

## 5. Run the Project

Run the following commands:

```bash
flutter pub get
flutter run
```

Before running the project, make sure to **select a simulator/device** from the Flutter device selector.