# 儿童时钟应用

一个专为儿童设计的简单时钟应用，具有友好的界面和实时时间显示。

## 🎯 功能特点

- 🕐 **实时时钟** - 显示当前时间（时:分:秒格式）
- 📅 **日期显示** - 显示年月日和星期
- 🌅 **智能问候** - 根据时间自动显示不同的问候语
- 🎨 **儿童友好** - 使用蓝色主题和圆润的设计
- 📱 **多平台支持** - 支持 Web、Android、iOS 等平台

## 🚀 快速开始

### 在 Web 浏览器中运行（推荐）

```bash
flutter run -d chrome --web-port=8080
```

然后在浏览器中打开：http://localhost:8080

### 在桌面应用中运行

```bash
flutter run -d macos
```

_注意：需要安装 Xcode 才能运行 macOS 版本_

### 在移动设备上运行

```bash
flutter run
```

_注意：需要配置 Android Studio 或 Xcode_

## 📋 系统要求

- Flutter SDK 3.9.2 或更高版本
- Dart SDK 3.9.2 或更高版本
- Chrome 浏览器（用于 Web 版本）

## 🛠️ 开发环境问题解决

### 如果遇到 Xcode 错误

如果您看到 `xcrun: error: unable to find utility "xcodebuild"` 错误，这是因为没有安装 Xcode。解决方案：

1. **使用 Web 版本**（推荐）：

   ```bash
   flutter run -d chrome
   ```

2. **安装 Xcode**（如果需要 macOS 版本）：
   - 从 App Store 安装 Xcode
   - 运行：`sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer`
   - 运行：`sudo xcodebuild -runFirstLaunch`

### 如果遇到 Android 错误

如果您看到 Android 相关错误，解决方案：

1. **使用 Web 版本**（推荐）
2. **安装 Android Studio**：
   - 下载并安装 Android Studio
   - 配置 Android SDK
   - 运行：`flutter doctor` 检查配置

## 📁 项目结构

```
child-clock/
├── lib/
│   └── main.dart          # 主应用文件
├── test/
│   └── widget_test.dart   # 测试文件
├── pubspec.yaml           # 项目依赖配置
├── analysis_options.yaml  # 代码分析配置
├── .gitignore            # Git忽略文件
└── README.md             # 项目说明文档
```

## 🎨 自定义应用

您可以通过修改 `lib/main.dart` 文件来自定义应用：

### 更改主题颜色

```dart
colorScheme: ColorScheme.fromSeed(seedColor: Colors.green), // 改为绿色主题
```

### 添加新功能

在 `ClockPage` 类中添加新的 Widget 组件

### 修改问候语

编辑 `_getGreeting()` 方法来自定义不同时间的问候语

## 🔧 构建发布版本

### Web 版本

```bash
flutter build web
```

构建后的文件在 `build/web/` 目录

### Android APK

```bash
flutter build apk
```

_需要 Android 开发环境_

### iOS 应用

```bash
flutter build ios
```

_需要 Xcode 和 iOS 开发环境_

## 🆘 常见问题

**Q: 为什么选择 Chrome 而不是 macOS 版本？**
A: 因为您的系统没有安装 Xcode，Chrome 版本不需要额外的开发工具链，可以直接运行。

**Q: 如何停止应用？**
A: 在终端中按 `Ctrl+C` 停止应用。

**Q: 如何重新启动应用？**
A: 运行 `flutter run -d chrome` 命令。

## 📄 许可证

此项目仅供学习和个人使用。

---

🎉 **享受您的儿童时钟应用！** 🎉
