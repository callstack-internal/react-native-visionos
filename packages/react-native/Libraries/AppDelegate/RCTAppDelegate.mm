/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import "RCTAppDelegate.h"
#import <React/RCTCxxBridgeDelegate.h>
#import <React/RCTRootView.h>
#import <React/RCTSurfacePresenterBridgeAdapter.h>
#import <react/renderer/runtimescheduler/RuntimeScheduler.h>
#import "RCTAppSetupUtils.h"
#import <React/RCTUtils.h>
#import "RCTLegacyInteropComponents.h"

#if RCT_NEW_ARCH_ENABLED
#import <React/CoreModulesPlugins.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTComponentViewFactory.h>
#import <React/RCTComponentViewProtocol.h>
#import <React/RCTFabricSurface.h>
#import <React/RCTLegacyViewManagerInteropComponentView.h>
#import <React/RCTSurfaceHostingProxyRootView.h>
#import <React/RCTSurfacePresenter.h>
#import <ReactCommon/RCTContextContainerHandling.h>
#if USE_HERMES
#import <ReactCommon/RCTHermesInstance.h>
#else
#import <ReactCommon/RCTJscInstance.h>
#endif
#import <ReactCommon/RCTHost+Internal.h>
#import <ReactCommon/RCTHost.h>
#import <ReactCommon/RCTTurboModuleManager.h>
#import <react/config/ReactNativeConfig.h>
#import <react/renderer/runtimescheduler/RuntimeScheduler.h>
#import <react/renderer/runtimescheduler/RuntimeSchedulerCallInvoker.h>
#import <react/runtime/JSEngineInstance.h>

static NSString *const kRNConcurrentRoot = @"concurrentRoot";

@interface RCTAppDelegate () <
    RCTTurboModuleManagerDelegate,
    RCTComponentViewFactoryComponentProvider,
    RCTContextContainerHandling> {
  std::shared_ptr<const facebook::react::ReactNativeConfig> _reactNativeConfig;
  facebook::react::ContextContainer::Shared _contextContainer;
}
@end

#endif

static NSDictionary *updateInitialProps(NSDictionary *initialProps, BOOL isFabricEnabled)
{
#ifdef RCT_NEW_ARCH_ENABLED
  NSMutableDictionary *mutableProps = [initialProps mutableCopy] ?: [NSMutableDictionary new];
  // Hardcoding the Concurrent Root as it it not recommended to
  // have the concurrentRoot turned off when Fabric is enabled.
  mutableProps[kRNConcurrentRoot] = @(isFabricEnabled);
  return mutableProps;
#else
  return initialProps;
#endif
}

@interface RCTAppDelegate () <RCTCxxBridgeDelegate> {
  std::shared_ptr<facebook::react::RuntimeScheduler> _runtimeScheduler;
}
@end

@implementation RCTAppDelegate {
#if RCT_NEW_ARCH_ENABLED
  RCTHost *_reactHost;
#endif
}

#if RCT_NEW_ARCH_ENABLED
- (instancetype)init
{
  if (self = [super init]) {
    _contextContainer = std::make_shared<facebook::react::ContextContainer const>();
    _reactNativeConfig = std::make_shared<facebook::react::EmptyReactNativeConfig const>();
    _contextContainer->insert("ReactNativeConfig", _reactNativeConfig);
  }
  return self;
}
#endif

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  BOOL enableTM = NO;
  BOOL enableBridgeless = NO;
  BOOL fabricEnabled = NO;
#if RCT_NEW_ARCH_ENABLED
  enableTM = self.turboModuleEnabled;
  enableBridgeless = self.bridgelessEnabled;
  fabricEnabled = [self fabricEnabled];
#endif
  
  RCTAppSetupPrepareApp(application, enableTM);

    
#if TARGET_OS_VISION
  /// Bail out of UIWindow initializaiton to support multi-window scenarios in SwiftUI lifecycle.
  return YES;
#else
  UIView* rootView = [self viewWithModuleName:self.moduleName initialProperties:[self prepareInitialProps] launchOptions:launchOptions];
    
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  
  UIViewController *rootViewController = [self createRootViewController];
  [self setRootView:rootView toRootViewController:rootViewController];
  self.window.rootViewController = rootViewController;
  self.window.windowScene.delegate = self;
  [self.window makeKeyAndVisible];

  return YES;
#endif
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Noop
}

- (UIView *)viewWithModuleName:(NSString *)moduleName initialProperties:(NSDictionary*)initialProperties launchOptions:(NSDictionary*)launchOptions {
  BOOL enableTM = NO;
  BOOL enableBridgeless = NO;
  BOOL fabricEnabled = NO;
#if RCT_NEW_ARCH_ENABLED
  enableTM = self.turboModuleEnabled;
  enableBridgeless = self.bridgelessEnabled;
  fabricEnabled = [self fabricEnabled];
#endif
  UIView *rootView;
  
  if (enableBridgeless) {
#if RCT_NEW_ARCH_ENABLED
    // Enable native view config interop only if both bridgeless mode and Fabric is enabled.
    RCTSetUseNativeViewConfigsInBridgelessMode(fabricEnabled);
    
    // Enable TurboModule interop by default in Bridgeless mode
    RCTEnableTurboModuleInterop(YES);
    RCTEnableTurboModuleInteropBridgeProxy(YES);
    
    [self createReactHost];
    [self unstable_registerLegacyComponents];
    [RCTComponentViewFactory currentComponentViewFactory].thirdPartyFabricComponentsProvider = self;
    RCTFabricSurface *surface = [_reactHost createSurfaceWithModuleName:moduleName initialProperties:initialProperties];
    
    RCTSurfaceHostingProxyRootView *surfaceHostingProxyRootView = [[RCTSurfaceHostingProxyRootView alloc]
                                                                   initWithSurface:surface
                                                                   sizeMeasureMode:RCTSurfaceSizeMeasureModeWidthExact | RCTSurfaceSizeMeasureModeHeightExact];
    
    rootView = (RCTRootView *)surfaceHostingProxyRootView;
#endif
  } else {
    if (!self.bridge) {
      self.bridge = [self createBridgeWithDelegate:self launchOptions:launchOptions];
    }
#if RCT_NEW_ARCH_ENABLED
    self.bridgeAdapter = [[RCTSurfacePresenterBridgeAdapter alloc] initWithBridge:self.bridge
                                                                 contextContainer:_contextContainer];
    self.bridge.surfacePresenter = self.bridgeAdapter.surfacePresenter;
    
    [self unstable_registerLegacyComponents];
    [RCTComponentViewFactory currentComponentViewFactory].thirdPartyFabricComponentsProvider = self;
#endif
    
    rootView = [self createRootViewWithBridge:self.bridge moduleName:moduleName initProps:initialProperties];
  }
  return rootView;
}

- (NSURL *)sourceURLForBridge:(RCTBridge *)bridge
{
  [NSException raise:@"RCTBridgeDelegate::sourceURLForBridge not implemented"
              format:@"Subclasses must implement a valid sourceURLForBridge method"];
  return nil;
}

- (NSDictionary *)prepareInitialProps
{
  return self.initialProps;
}

- (RCTBridge *)createBridgeWithDelegate:(id<RCTBridgeDelegate>)delegate launchOptions:(NSDictionary *)launchOptions
{
  return [[RCTBridge alloc] initWithDelegate:delegate launchOptions:launchOptions];
}

- (UIView *)createRootViewWithBridge:(RCTBridge *)bridge
                          moduleName:(NSString *)moduleName
                           initProps:(NSDictionary *)initProps
{
  BOOL enableFabric = NO;
#if RCT_NEW_ARCH_ENABLED
  enableFabric = self.fabricEnabled;
#endif
  UIView *rootView = RCTAppSetupDefaultRootView(bridge, moduleName, initProps, enableFabric);

  rootView.backgroundColor = [UIColor systemBackgroundColor];

  return rootView;
}

- (UIViewController *)createRootViewController
{
  return [UIViewController new];
}

- (void)setRootView:(UIView *)rootView toRootViewController:(UIViewController *)rootViewController
{
  rootViewController.view = rootView;
}

- (BOOL)runtimeSchedulerEnabled
{
  return YES;
}

#pragma mark - UISceneDelegate
- (void)windowScene:(UIWindowScene *)windowScene
    didUpdateCoordinateSpace:(id<UICoordinateSpace>)previousCoordinateSpace
        interfaceOrientation:(UIInterfaceOrientation)previousInterfaceOrientation
             traitCollection:(UITraitCollection *)previousTraitCollection API_AVAILABLE(ios(13.0))
{
  [[NSNotificationCenter defaultCenter] postNotificationName:RCTWindowFrameDidChangeNotification object:self];
}

#pragma mark - RCTCxxBridgeDelegate
- (std::unique_ptr<facebook::react::JSExecutorFactory>)jsExecutorFactoryForBridge:(RCTBridge *)bridge
{
  _runtimeScheduler = std::make_shared<facebook::react::RuntimeScheduler>(RCTRuntimeExecutorFromBridge(bridge));
#if RCT_NEW_ARCH_ENABLED
  std::shared_ptr<facebook::react::CallInvoker> callInvoker =
      std::make_shared<facebook::react::RuntimeSchedulerCallInvoker>(_runtimeScheduler);
  RCTTurboModuleManager *turboModuleManager = [[RCTTurboModuleManager alloc] initWithBridge:bridge
                                                                                   delegate:self
                                                                                  jsInvoker:callInvoker];
  _contextContainer->erase("RuntimeScheduler");
  _contextContainer->insert("RuntimeScheduler", _runtimeScheduler);
  return RCTAppSetupDefaultJsExecutorFactory(bridge, turboModuleManager, _runtimeScheduler);
#else
  return RCTAppSetupJsExecutorFactoryForOldArch(bridge, _runtimeScheduler);
#endif
}
#pragma mark - New Arch Enabled settings

- (BOOL)newArchEnabled
{
#if RCT_NEW_ARCH_ENABLED
  return YES;
#else
  return NO;
#endif
}

- (BOOL)turboModuleEnabled
{
  return [self newArchEnabled];
}

- (BOOL)fabricEnabled
{
  return [self newArchEnabled];
}

- (BOOL)bridgelessEnabled
{
  return NO;
}

#if RCT_NEW_ARCH_ENABLED

#pragma mark - New Arch Utilities

- (void)unstable_registerLegacyComponents
{
  for (NSString *legacyComponent in [RCTLegacyInteropComponents legacyInteropComponents]) {
    [RCTLegacyViewManagerInteropComponentView supportLegacyViewManagerWithName:legacyComponent];
  }
}

#pragma mark - RCTComponentViewFactoryComponentProvider

- (NSDictionary<NSString *, Class<RCTComponentViewProtocol>> *)thirdPartyFabricComponents
{
  return @{};
}

#pragma mark - RCTTurboModuleManagerDelegate

- (Class)getModuleClassFromName:(const char *)name
{
  return RCTCoreModulesClassProvider(name);
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const std::string &)name
                                                      jsInvoker:(std::shared_ptr<facebook::react::CallInvoker>)jsInvoker
{
  return nullptr;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const std::string &)name
                                                     initParams:
                                                         (const facebook::react::ObjCTurboModule::InitParams &)params
{
  return nullptr;
}

- (id<RCTTurboModule>)getModuleInstanceFromClass:(Class)moduleClass
{
  return RCTAppSetupDefaultModuleFromClass(moduleClass);
}

#pragma mark - New Arch Utilities

- (void)createReactHost
{
  if (_reactHost != nil) {
    return;
  }
  __weak __typeof(self) weakSelf = self;
  _reactHost = [[RCTHost alloc] initWithBundleURL:[self getBundleURL]
                                     hostDelegate:nil
                       turboModuleManagerDelegate:self
                                 jsEngineProvider:^std::shared_ptr<facebook::react::JSEngineInstance>() {
                                   return [weakSelf createJSEngineInstance];
                                 }];
  [_reactHost setBundleURLProvider:^NSURL *() {
    return [weakSelf getBundleURL];
  }];
  [_reactHost setContextContainerHandler:self];
  [_reactHost start];
}

- (std::shared_ptr<facebook::react::JSEngineInstance>)createJSEngineInstance
{
#if USE_HERMES
  return std::make_shared<facebook::react::RCTHermesInstance>(_reactNativeConfig, nullptr);
#else
  return std::make_shared<facebook::react::RCTJscInstance>();
#endif
}

- (void)didCreateContextContainer:(std::shared_ptr<facebook::react::ContextContainer>)contextContainer
{
  contextContainer->insert("ReactNativeConfig", _reactNativeConfig);
}

- (NSURL *)getBundleURL
{
  [NSException raise:@"RCTAppDelegate::getBundleURL not implemented"
              format:@"Subclasses must implement a valid getBundleURL method"];
  return nullptr;
}

#endif

@end

