#import <React/RCTXRModule.h>

#import <FBReactNativeSpec_visionOS/FBReactNativeSpec_visionOS.h>

#import <React/RCTBridge.h>
#import <React/RCTConvert.h>
#import <React/RCTUtils.h>
#import "RCTXR-Swift.h"

@interface RCTXRModule () <NativeXRModuleSpec>
@end

@implementation RCTXRModule {
  UIViewController *_immersiveBridgeView;
  NSString *_currentSessionId;
}

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(endSession
                  : (RCTPromiseResolveBlock)resolve reject
                  : (RCTPromiseRejectBlock)reject)
{
  [self removeViewController:self->_immersiveBridgeView];
  self->_immersiveBridgeView = nil;
  RCTExecuteOnMainQueue(^{
    if (self->_currentSessionId != nil) {
      NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
      [notificationCenter postNotificationName:@"RCTDismissImmersiveSpace" object:self userInfo:@{@"id": self->_currentSessionId }];
    }
  });
  _currentSessionId = nil;
  resolve(nil);
}


RCT_EXPORT_METHOD(requestSession
                  : (NSString *)sessionId userInfo
                  : (NSDictionary *)userInfo resolve
                  : (RCTPromiseResolveBlock)resolve reject
                  : (RCTPromiseRejectBlock)reject)
{
  RCTExecuteOnMainQueue(^{
    UIWindow *keyWindow = RCTKeyWindow();
    UIViewController *rootViewController = keyWindow.rootViewController;
    
    if (self->_immersiveBridgeView == nil) {
      NSMutableDictionary *userInfoDict = [[NSMutableDictionary alloc] init];
      [userInfoDict setValue:sessionId forKey:@"id"];
      if (userInfo != nil) {
        [userInfoDict setValue:userInfo forKey:@"userInfo"];
      }
      NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
          [notificationCenter postNotificationName:@"RCTOpenImmersiveSpace" object:self userInfo:userInfoDict];
      self->_currentSessionId = sessionId;
      
      self->_immersiveBridgeView = [SwiftUIBridgeFactory makeImmersiveBridgeViewWithSpaceId:sessionId
                                                                            completionHandler:^(enum ImmersiveSpaceResult result){
        if (result == ImmersiveSpaceResultError) {
          reject(@"ERROR", @"Immersive Space failed to open, the system cannot fulfill the request.", nil);
          [self removeViewController:self->_immersiveBridgeView];
          self->_immersiveBridgeView = nil;
        } else if (result == ImmersiveSpaceResultUserCancelled) {
          reject(@"ERROR", @"Immersive Space canceled by user", nil);
          [self removeViewController:self->_immersiveBridgeView];
          self->_immersiveBridgeView = nil;
        } else if (result == ImmersiveSpaceResultOpened) {
          resolve(nil);
        }
      }];
      
      [rootViewController.view addSubview:self->_immersiveBridgeView.view];
      [rootViewController addChildViewController:self->_immersiveBridgeView];
      [self->_immersiveBridgeView didMoveToParentViewController:rootViewController];
    } else {
      reject(@"ERROR", @"Immersive Space already opened", nil);
    }
  });
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
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSMutableDictionary *userInfoDict = [[NSMutableDictionary alloc] init];
    [userInfoDict setValue:windowId forKey:@"id"];
    if (userInfo != nil) {
      [userInfoDict setValue:userInfo forKey:@"userInfo"];
    }
    [notificationCenter postNotificationName:@"RCTOpenWindow" object:self userInfo:userInfoDict];
    resolve(nil);
  });
}

RCT_EXPORT_METHOD(closeWindow
                  : (NSString *)windowId resolve
                  : (RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
  RCTExecuteOnMainQueue(^{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:@"RCTDismissWindow" object:self userInfo:@{@"id": windowId}];
    resolve(nil);
  });
}

- (facebook::react::ModuleConstants<JS::NativeXRModule::Constants::Builder>)constantsToExport {
  return [self getConstants];
}

- (facebook::react::ModuleConstants<JS::NativeXRModule::Constants>)getConstants {
  __block facebook::react::ModuleConstants<JS::NativeXRModule::Constants> constants;
  RCTUnsafeExecuteOnMainQueueSync(^{
    constants = facebook::react::typedConstants<JS::NativeXRModule::Constants>({
      .supportsMultipleScenes = RCTSharedApplication().supportsMultipleScenes
    });
  });
  
  return constants;
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
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSMutableDictionary *userInfoDict = [[NSMutableDictionary alloc] init];
    [userInfoDict setValue:windowId forKey:@"id"];
    if (userInfo != nil) {
      [userInfoDict setValue:userInfo forKey:@"userInfo"];
    }
    [notificationCenter postNotificationName:@"RCTUpdateWindow" object:self userInfo:userInfoDict];
    resolve(nil);
  });
}

- (void)removeViewController:(UIViewController*)viewController
{
  RCTExecuteOnMainQueue(^{
    [viewController willMoveToParentViewController:nil];
    [viewController.view removeFromSuperview];
    [viewController removeFromParentViewController];
  });
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const facebook::react::ObjCTurboModule::InitParams &)params {
  return std::make_shared<facebook::react::NativeXRModuleSpecJSI>(params);
}

@end
