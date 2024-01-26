#import <React/RCTSpatialManager.h>

#import <FBReactNativeSpec/FBReactNativeSpec.h>
#import <React/RCTBridge.h>
#import <React/RCTConvert.h>
#import <React/RCTUtils.h>
#import "RCTSpatial-Swift.h"

@interface RCTSpatialManager () <NativeSpatialManagerSpec>
@end

@implementation RCTSpatialManager {
  UIViewController *_immersiveBridgeView;
}

RCT_EXPORT_MODULE()

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const facebook::react::ObjCTurboModule::InitParams &)params {
  return std::make_shared<facebook::react::NativeSpatialManagerSpecJSI>(params);
}

RCT_EXPORT_METHOD(dismissImmersiveSpace
                  : (RCTPromiseResolveBlock)resolve reject
                  : (RCTPromiseRejectBlock)reject)
{
  RCTExecuteOnMainQueue(^{
    [self->_immersiveBridgeView willMoveToParentViewController:nil];
    [self->_immersiveBridgeView.view removeFromSuperview];
    [self->_immersiveBridgeView removeFromParentViewController];
    self->_immersiveBridgeView = nil;
    
    resolve(nil);
  });
}

RCT_EXPORT_METHOD(openImmersiveSpace
                  : (NSString *)sceneId resolve
                  : (RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
  RCTExecuteOnMainQueue(^{
    UIWindow *keyWindow = RCTKeyWindow();
    UIViewController *rootViewController = keyWindow.rootViewController;
    
    if (self->_immersiveBridgeView == nil) {
      self->_immersiveBridgeView = [ImmersiveBridgeFactory makeImmersiveBridgeViewWithSpaceId:sceneId
                                                                         completionHandler:^(enum ImmersiveSpaceResult result){
        if (result == ImmersiveSpaceResultError) {
          reject(@"ERROR", @"Immersive Space failed to open, the system cannot fulfill the request.", nil);
        } else if (result == ImmersiveSpaceResultUserCancelled) {
          reject(@"ERROR", @"Immersive Space canceled by user", nil);
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

@end
