import SwiftUI

/*
 * Use this struct in SwiftUI context to present React Native rootView.
 *
 * Example:
 * ```
 *  WindowGroup {
 *    RCTRootViewRepresentable(moduleName: "RNTesterApp", initialProps: [:])
 *  }
 * ```
 */
public struct RCTRootViewRepresentable: UIViewControllerRepresentable {
  var moduleName: String
  var initialProps: [AnyHashable: Any]?
  
  public init(moduleName: String, initialProps: [AnyHashable : Any]?) {
    self.moduleName = moduleName
    self.initialProps = initialProps
  }
  
  public func makeUIViewController(context: Context) -> UIViewController {
    RCTReactViewController(moduleName: moduleName, initProps: initialProps)
  }
  
  public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    // noop
  }
}
