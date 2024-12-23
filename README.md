# 📅 MDatePicker

> The missing SiwftUI date picker for macOS

![MDatePicker](Resources/Calendar.png)

## ✨ Features

- 🎯 Native macOS look and feel
- 🖥️ Clean and minimal UI
- 📱 Responsive design
- 🎨 Follows system appearance (Light/Dark mode)

## 🚀 Installation

To integrate this package into your project, use the following repository URL:

```plaintext
https://github.com/Momentumos/MDatePicker
```

1. Open your project in Xcode.
2. Navigate to **File > Add Packages**.
3. Enter the URL above and follow the prompts to add the package to your project.

## 💡 Usage

Import MDatePicker into your macOS project and use it like this:

```swift
//Define a state variable to hold the picked date
//For picking single dates
@State var pickedSingleDate: MPickedDate? = .single(.now)

//For picking a date range
@State var dateValue: MPickedDate? = .range(Calendar.current.date(byAdding: .day, value: -2, to: .now) ?? .now, Calendar.current.date(byAdding: .day, value: 2, to: .now) ?? .now)

//Use in any view
MDatePicker(pickedDate: $dateValue)
```

## 🛠️ Requirements
- macOS 14.0
- iOS 13.0

## 🤝 Contributing
Contributions are welcome! Feel free to:

1. Fork the project
2. Create your feature branch
3. Submit a pull request

## ⭐ Show Your Support
Give a ⭐️ if this project helped you!
