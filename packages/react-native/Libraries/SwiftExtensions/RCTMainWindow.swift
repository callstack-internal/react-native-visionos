import SwiftUI
import React


extension NSNotification.Name {
    static let openImmersiveSpace = NSNotification.Name("RCTOpenImmersiveSpaceNotification")
    static let dismissImmersiveSpace = NSNotification.Name("RCTDismissImmersiveSpaceNotification")
}

/**
 This SwiftUI struct returns main React Native scene. It should be used only once as it conains setup code.
 
 Example:
 ```swift
 @main
 struct YourApp: App {
   @UIApplicationDelegateAdaptor var delegate: AppDelegate
   
   var body: some Scene {
     RCTMainWindow(moduleName: "YourApp")
   }
 }
 ```
 
 Note: If you want to create additional windows in your app, create a new `WindowGroup {}` and pass it a `RCTRootViewRepresentable`.
*/
public struct RCTMainWindow: Scene {
  var moduleName: String
  var initialProps: RCTRootViewRepresentable.InitialPropsType
  
  public init(moduleName: String, initialProps: RCTRootViewRepresentable.InitialPropsType = nil) {
    self.moduleName = moduleName
    self.initialProps = initialProps
  }
  
  public var body: some Scene {
    WindowGroup {
      RCTRootViewRepresentable(moduleName: moduleName, initialProps: initialProps)
        .modifier(EnvironmentListener())
    }
  }
}

struct EnvironmentListener: ViewModifier {
  @Environment(\.openImmersiveSpace) private var openImmersiveSpace
  @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
  
  func body(content: Content) -> some View {
    content
      .onReceive(NotificationCenter.default.publisher(for: .openImmersiveSpace)) { data in
        print("open immersive space")
        Task { await openImmersiveSpace(id: "ImmersiveSpace") }
      }
      .onReceive(NotificationCenter.default.publisher(for: .dismissImmersiveSpace)) { data in
        print("dismiss immersive space")
        Task { await dismissImmersiveSpace() }
      }
  }
}
