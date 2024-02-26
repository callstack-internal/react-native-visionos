import SwiftUI
import Observation

@Observable
public class RCTSceneData: Identifiable {
  public var id: String
  public var props: Dictionary<String, AnyHashable>?
  
  init(id: String, props: Dictionary<String, AnyHashable>?) {
    self.id = id
    self.props = props
  }
}

extension RCTSceneData: Equatable {
  public static func == (lhs: RCTSceneData, rhs: RCTSceneData) -> Bool {
    lhs.id == rhs.id && NSDictionary(dictionary: lhs.props ?? [:]).isEqual(to: rhs.props ?? [:])
  }
}

@Observable
public class RCTReactContext {
  public var scenes: Dictionary<String, RCTSceneData> = [:]
  
  public func getSceneData(id: String) -> RCTSceneData? {
    return scenes[id]
  }
}

extension RCTReactContext: Equatable {
  public static func == (lhs: RCTReactContext, rhs: RCTReactContext) -> Bool {
    NSDictionary(dictionary: lhs.scenes).isEqual(to: rhs.scenes)
  }
}

public extension EnvironmentValues {
  var reactContext: RCTReactContext {
    get { self[RCTSceneContextKey.self] }
    set { self[RCTSceneContextKey.self] = newValue }
  }
}

private struct RCTSceneContextKey: EnvironmentKey {
  static var defaultValue: RCTReactContext = RCTReactContext()
}
