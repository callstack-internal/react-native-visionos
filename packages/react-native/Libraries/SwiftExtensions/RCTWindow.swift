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
  @Environment(\.scenePhase) private var scenePhase

  
  public init(id: String, moduleName: String, sceneData: RCTSceneData?) {
    self.id = id
    self.moduleName = moduleName
    self.sceneData = sceneData
  }
  
  public var body: some Scene {
    WindowGroup(id: id) {
      Group {
        if let sceneData {
          RCTRootViewRepresentable(moduleName: moduleName, initialProps: sceneData.props)
            .onChange(of: scenePhase) { _, newValue in
              postWindowStateNotification(windowId: id, state: newValue)
            }
        }
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
  public init(id: String, sceneData: RCTSceneData?) {
    self.id = id
    self.moduleName = id
    self.sceneData = sceneData
  }
}
