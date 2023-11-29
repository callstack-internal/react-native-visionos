<h1 align="center">
  <a href="https://reactnative.dev/">
    React Native Vision OS
  </a>
</h1>

<p align="center">
  <strong>Learn once, write anywhere:</strong><br>
  Build spatial apps with React.
</p>

React Native Vision OS allows you to write visionOS with full support for platform SDK. This is a full fork of the main repository with changes needed to support visionOS.

> [!CAUTION]
> This project is still at an early stage of development and is not ready for production use.

## New project creation

1. Make sure you have a [proper development environment setup](https://reactnative.dev/docs/environment-setup)
2. Download the latest Xcode beta [here](https://developer.apple.com/xcode/).
3. Install visionOS Simulator runtime.
4. Initialize the project using this command:

```
npx @callstack/react-native-visionos@latest init YourApp
```
5. Next, go to `YourApp/visionos` folder and run following commands to install Pods:

```
cd visionos
bundle install
bundle exec pod install
```

6. Open `YourApp/visionos/YourApp.xcworkspace` using Xcode 15 Beta.
7. Build the app by clicking the "Run" button in Xcode.

## Contributing

1. Follow the same steps as in the `New project creation` section.
2. Checkout `rn-tester` [README.md](./packages/rn-tester/README.md) to build React Native from source.
