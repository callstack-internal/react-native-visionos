import SwiftUI
import React

/**
 `RCTWindow` is a SwiftUI struct that returns additional scenes.
 
 Example usage:
 ```
 RCTWindow(id: "SecondWindow", sceneData: reactContext.getSceneData(id: "SecondWindow"))
 ```
 */
public struct RCTWindow : Scene {
  var id: String
  var sceneData: RCTSceneData?
  var moduleName: String
  var contentView: AnyView?

  func getRootView(sceneData: RCTSceneData?) -> RCTRootViewRepresentable {
    return RCTRootViewRepresentable(moduleName: moduleName, initialProps: sceneData?.props ?? [:])
  }
  
  public var body: some Scene {
    WindowGroup(id: id) {
      Group {
        contentView
      }
      .onAppear {
        if sceneData == nil {
          RCTFatal(RCTErrorWithMessage("Passed scene data is nil, make sure to pass sceneContext to RCTWindow() in App.swift"))
        }
      }
    }
  }
}

extension RCTWindow {
  /// Creates new RCTWindow.
  ///
  /// - Parameters:
  ///   - id: Unique identifier of the window.
  ///   - moduleName: Name of the module registered using `AppRegistry.registerComponent()`
  ///   - sceneData: Data of the scene. Used to sync JS state between windows.
  public init(id: String, moduleName: String, sceneData: RCTSceneData?) {
    self.id = id
    self.moduleName = moduleName
    self.sceneData = sceneData
    self.contentView = AnyView(getRootView(sceneData: sceneData))
  }
  
  /// Creates new RCTWindow with additional closure to allow applying modifiers to rootView.
  ///
  /// - Parameters:
  ///   - id: Unique identifier of the window.
  ///   - moduleName: Name of the module registered using `AppRegistry.registerComponent()`
  ///   - sceneData: Data of the scene. Used to sync JS state between windows.
  ///   - contentView: Closure which accepts rootView, allows to apply additional modifiers to React Native rootView.
  public init<Content: View>(
    id: String,
    moduleName: String,
    sceneData: RCTSceneData?,
    @ViewBuilder contentView: @escaping (_ view: RCTRootViewRepresentable) -> Content
  ) {
    self.id = id
    self.moduleName = moduleName
    self.sceneData = sceneData
    self.contentView = AnyView(contentView(getRootView(sceneData: sceneData)))
  }
  
  /// Creates new RCTWindow with additional closure to allow applying modifiers to rootView.
  ///
  /// - Parameters:
  ///   - id: Unique identifier of the window. Same id will be used for moduleName.
  ///   - sceneData: Data of the scene. Used to sync JS state between windows.
  ///   - contentView: Closure which accepts rootView, allows to apply additional modifiers to React Native rootView.
  public init<Content: View>(
    id: String,
    sceneData: RCTSceneData?,
    @ViewBuilder contentView: @escaping (_ view: RCTRootViewRepresentable) -> Content
  ) {
    self.id = id
    self.moduleName = id
    self.sceneData = sceneData
    self.contentView = AnyView(contentView(getRootView(sceneData: sceneData)))
  }
  
  /// Creates new RCTWindow.
  ///
  /// - Parameters:
  ///   - id: Unique identifier of the window. Same id will be used for moduleName.
  ///   - sceneData: Data of the scene. Used to sync JS state between windows.
  public init(id: String, sceneData: RCTSceneData?) {
    self.id = id
    self.moduleName = id
    self.sceneData = sceneData
    self.contentView = AnyView(getRootView(sceneData: sceneData))
  }
}
