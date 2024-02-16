import SwiftUI
import React
import React_RCTSwiftExtensions

@main
struct RNTesterApp: App {
  @UIApplicationDelegateAdaptor var delegate: AppDelegate
  @Environment(\.reactContext) private var reactContext
  
  @State private var immersionLevel: ImmersionStyle = .full
  
  var body: some Scene {
    RCTMainWindow(moduleName: "RNTesterApp")
    
    RCTWindow(id: "SecondWindow", sceneData: reactContext.getSceneData(id: "SecondWindow"))
      .defaultSize(CGSize(width: 400, height: 700))
    
    ImmersiveSpace(id: "TestImmersiveSpace") {}
     .immersionStyle(selection: $immersionLevel, in: .mixed, .progressive, .full)
  }
}
