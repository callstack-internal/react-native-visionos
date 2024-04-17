#import <React/RCTWindowManager.h>

#import <FBReactNativeSpec_visionOS/FBReactNativeSpec_visionOS.h>

#import <React/RCTBridge.h>
#import <React/RCTConvert.h>
#import <React/RCTUtils.h>

// Events
static NSString *const RCTOpenWindow = @"RCTOpenWindow";
static NSString *const RCTDismissWindow = @"RCTDismissWindow";
static NSString *const RCTUpdateWindow = @"RCTUpdateWindow";
static NSString *const RCTWindowStateDidChangeEvent = @"windowStateDidChange";

static NSString *const RCTWindowStateDidChange = @"RCTWindowStateDidChange";

@interface RCTWindowManager () <NativeWindowManagerSpec> {
  BOOL _hasAnyListeners;
}
@end

@implementation RCTWindowManager

RCT_EXPORT_MODULE(WindowManager)

- (void)initialize {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(handleWindowStateChanges:)
                                               name:RCTWindowStateDidChange
                                             object:nil];
}

- (void)invalidate {
  [super invalidate];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)startObserving
{
  _hasAnyListeners = YES;
}

- (void)stopObserving
{
  _hasAnyListeners = NO;
}

RCT_EXPORT_METHOD(openWindow
                  : (NSString *)windowId userInfo
                  : (NSDictionary *)userInfo resolve
                  : (RCTPromiseResolveBlock)resolve reject
                  : (RCTPromiseRejectBlock)reject)
{
  RCTExecuteOnMainQueue(^{
    if (!RCTSharedApplication().supportsMultipleScenes) {
      reject(@"ERROR", @"Multiple scenes not supported", nil);
    }
    NSMutableDictionary *userInfoDict = [[NSMutableDictionary alloc] init];
    [userInfoDict setValue:windowId forKey:@"id"];
    if (userInfo != nil) {
      [userInfoDict setValue:userInfo forKey:@"userInfo"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:RCTOpenWindow object:self userInfo:userInfoDict];
    resolve(nil);
  });
}

RCT_EXPORT_METHOD(closeWindow
                  : (NSString *)windowId resolve
                  : (RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
  RCTExecuteOnMainQueue(^{
    [[NSNotificationCenter defaultCenter] postNotificationName:RCTDismissWindow object:self userInfo:@{@"id": windowId}];
    resolve(nil);
  });
}

RCT_EXPORT_METHOD(updateWindow
                  : (NSString *)windowId userInfo
                  : (NSDictionary *)userInfo resolve
                  : (RCTPromiseResolveBlock)resolve reject
                  : (RCTPromiseRejectBlock)reject)
{
  RCTExecuteOnMainQueue(^{
    if (!RCTSharedApplication().supportsMultipleScenes) {
      reject(@"ERROR", @"Multiple scenes not supported", nil);
    }
    NSMutableDictionary *userInfoDict = [[NSMutableDictionary alloc] init];
    [userInfoDict setValue:windowId forKey:@"id"];
    if (userInfo != nil) {
      [userInfoDict setValue:userInfo forKey:@"userInfo"];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:RCTUpdateWindow object:self userInfo:userInfoDict];
    resolve(nil);
  });
}

- (void) handleWindowStateChanges:(NSNotification *)notification {
  
  if (_hasAnyListeners) {
   [self sendEventWithName:RCTWindowStateDidChangeEvent body:notification.userInfo];
  }
}

- (NSArray<NSString *> *)supportedEvents {
  return @[RCTWindowStateDidChangeEvent];
}

- (facebook::react::ModuleConstants<JS::NativeWindowManager::Constants::Builder>)constantsToExport {
  return [self getConstants];
}

- (facebook::react::ModuleConstants<JS::NativeWindowManager::Constants>)getConstants {
  __block facebook::react::ModuleConstants<JS::NativeWindowManager::Constants> constants;
  RCTUnsafeExecuteOnMainQueueSync(^{
    constants = facebook::react::typedConstants<JS::NativeWindowManager::Constants>({
      .supportsMultipleScenes = RCTSharedApplication().supportsMultipleScenes
    });
  });
  
  return constants;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const facebook::react::ObjCTurboModule::InitParams &)params {
  return std::make_shared<facebook::react::NativeWindowManagerSpecJSI>(params);
}

+ (BOOL)requiresMainQueueSetup {
  return YES;
}

- (dispatch_queue_t)methodQueue
{
  return dispatch_get_main_queue();
}

@end
