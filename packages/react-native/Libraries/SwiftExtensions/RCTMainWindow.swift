import SwiftUI

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
 
 Note: If you want to create additional windows in your app, use `RCTWindow()`.
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
#if os(visionOS)
        .modifier(WindowHandlingModifier())
#endif
    }
  }
}

#if os(visionOS)
/**
 Handles data sharing between React Native and SwiftUI views.
 */
struct WindowHandlingModifier: ViewModifier {
  typealias UserInfoType = Dictionary<String, AnyHashable>
  
  @Environment(\.reactContext) private var reactContext
  @Environment(\.openWindow) private var openWindow
  @Environment(\.dismissWindow) private var dismissWindow
  
  func body(content: Content) -> some View {
    content
      .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RCTOpenWindow"))) { data in
        guard let id = data.userInfo?["id"] as? String else { return }
        reactContext.scenes.updateValue(RCTSceneData(id: id, props: data.userInfo?["userInfo"] as? UserInfoType), forKey: id)
        openWindow(id: id)
      }
      .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RCTUpdateWindow"))) { data in
        guard let id = data.userInfo?["id"] as? String else { return }
        if let userInfo = data.userInfo?["userInfo"] as? UserInfoType {
          reactContext.scenes[id]?.props = userInfo
        }
      }
      .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RCTDismissWindow"))) { data in
        if let id = data.userInfo?["id"] as? String {
          dismissWindow(id: id)
          reactContext.scenes.removeValue(forKey: id)
        }
      }
      .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RCTOpenImmersiveSpace"))) { data in
        guard let id = data.userInfo?["id"] as? String else { return }
        reactContext.scenes.updateValue(
          RCTSceneData(id: id, props: data.userInfo?["userInfo"] as? UserInfoType),
          forKey: id
        )
      }
      .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RCTDismissImmersiveSpace"))) { data in
        if let spaceId = data.userInfo?["id"] as? String {
          reactContext.scenes.removeValue(forKey: spaceId)
        }
      }
  }
}
#endif
