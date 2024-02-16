import SwiftUI

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
  
  public init(id: String, moduleName: String, sceneData: RCTSceneData?) {
    self.id = id
    self.moduleName = moduleName
    self.sceneData = sceneData
  }
  
  public var body: some Scene {
    WindowGroup(id: id) {
      if let sceneData {
        RCTRootViewRepresentable(moduleName: moduleName, initialProps: sceneData.props)
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
