import SwiftUI
import React

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
  var onOpenURLCallback: ((URL) -> ())?
  var devMenuPlacement: ToolbarPlacement = .bottomOrnament
  var contentView: AnyView?
  
  var rootView: RCTRootViewRepresentable {
    RCTRootViewRepresentable(moduleName: moduleName, initialProps: initialProps)
  }

  /// Creates new RCTMainWindowWindow.
  ///
  /// - Parameters:
  ///   - moduleName: Name of the module registered using `AppRegistry.registerComponent()`
  ///   - initialProps: Initial properties for this view.
  ///   - devMenuPlacement: Placement of the additional controls for triggering reload command and dev menu trigger.
  public init(
    moduleName: String,
    initialProps: RCTRootViewRepresentable.InitialPropsType = nil,
    devMenuPlacement: ToolbarPlacement = .bottomOrnament
  ) {
    self.moduleName = moduleName
    self.initialProps = initialProps
    self.devMenuPlacement = devMenuPlacement
    self.contentView = AnyView(rootView)
  }
  
  /// Creates new RCTMainWindowWindow.
  ///
  /// - Parameters:
  ///   - moduleName: Name of the module registered using `AppRegistry.registerComponent()`
  ///   - initialProps: Initial properties for this view.
  ///   - devMenuPlacement: Placement of the additional controls for triggering reload command and dev menu trigger.
  ///   - contentView: Closure which accepts rootView, allows to apply additional modifiers to React Native rootView.
  public init<Content: View>(
    moduleName: String,
    initialProps: RCTRootViewRepresentable.InitialPropsType = nil,
    devMenuPlacement: ToolbarPlacement = .bottomOrnament,
    @ViewBuilder contentView: @escaping (_ view: RCTRootViewRepresentable) -> Content
  ) {
    self.moduleName = moduleName
    self.initialProps = initialProps
    self.devMenuPlacement = devMenuPlacement
    self.contentView = AnyView(contentView(rootView))
  }
  
  public var body: some Scene {
    WindowGroup {
      contentView
        .modifier(WindowHandlingModifier())
        .onOpenURL(perform: { url in
          onOpenURLCallback?(url)
        })
#if DEBUG
        .toolbar {
          DevMenuView(placement: .bottomOrnament)
        }
#endif
    }
  }
}

extension RCTMainWindow {
  public func onOpenURL(perform action: @escaping (URL) -> ()) -> Self {
    var scene = self
    scene.onOpenURLCallback = action
    return scene
  }
}

/**
 Handles data sharing between React Native and SwiftUI views.
 */
public struct WindowHandlingModifier: ViewModifier {
  typealias UserInfoType = Dictionary<String, AnyHashable>
  
  @Environment(\.reactContext) private var reactContext
  @Environment(\.openWindow) private var openWindow
  @Environment(\.dismissWindow) private var dismissWindow
  @Environment(\.supportsMultipleWindows) private var supportsMultipleWindows
  
  public init() {}
  
  public func body(content: Content) -> some View {
    // Attach listeners only if app supports multiple windows
    if supportsMultipleWindows {
      content
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RCTOpenWindow"))) { data in
          guard let id = data.userInfo?["id"] as? String else { return }
          reactContext.scenes.updateValue(RCTSceneData(id: id, props: data.userInfo?["userInfo"] as? UserInfoType), forKey: id)
          openWindow(id: id)
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RCTUpdateWindow"))) { data in
          guard
            let id = data.userInfo?["id"] as? String,
            let userInfo = data.userInfo?["userInfo"] as? UserInfoType else { return }
          reactContext.scenes[id]?.props = userInfo
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RCTDismissWindow"))) { data in
          guard let id = data.userInfo?["id"] as? String else { return }
          dismissWindow(id: id)
          reactContext.scenes.removeValue(forKey: id)
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RCTOpenImmersiveSpace"))) { data in
          guard let id = data.userInfo?["id"] as? String else { return }
          reactContext.scenes.updateValue(
            RCTSceneData(id: id, props: data.userInfo?["userInfo"] as? UserInfoType),
            forKey: id
          )
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("RCTDismissImmersiveSpace"))) { data in
          guard let id = data.userInfo?["id"] as? String else { return }
          reactContext.scenes.removeValue(forKey: id)
        }
    } else {
      content
    }
  }
}

/**
 Toolbar which displays additional controls to easily open dev menu and trigger reload command.
 */
struct DevMenuView: ToolbarContent {
  let placement: ToolbarItemPlacement
  
  var body: some ToolbarContent {
    ToolbarItem(placement: placement) {
      Button(action: {
        RCTTriggerReloadCommandListeners("User Reload")
      }, label: {
        Image(systemName: "arrow.clockwise")
      })
    }
    ToolbarItem(placement: placement) {
      Button(action: {
        NotificationCenter.default.post(
          Notification(name: Notification.Name("RCTShowDevMenuNotification"), object: nil)
        )
      },
             label: {
        Image(systemName: "filemenu.and.selection")
      })
    }
  }
}
