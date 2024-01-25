#import <React/RCTSpatialManager.h>

#import <FBReactNativeSpec/FBReactNativeSpec.h>
#import <React/RCTBridge.h>
#import <React/RCTConvert.h>
#import <React/RCTUtils.h>

static NSString *const kOpenImmersiveSpace = @"RCTOpenImmersiveSpaceNotification";
static NSString *const kDismissImmersiveSpace = @"RCTDismissImmersiveSpaceNotification";

@interface RCTSpatialManager () <NativeSpatialManagerSpec>
@end

@implementation RCTSpatialManager

RCT_EXPORT_MODULE()

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const facebook::react::ObjCTurboModule::InitParams &)params {
  return std::make_shared<facebook::react::NativeSpatialManagerSpecJSI>(params);
}

RCT_EXPORT_METHOD(dismissImmersiveSpace
                  : (RCTPromiseResolveBlock)resolve reject
                  : (RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:kDismissImmersiveSpace object:self];
  });
}

RCT_EXPORT_METHOD(openImmersiveSpace
                  : (NSString *)sceneId resolve
                  : (RCTPromiseResolveBlock)resolve reject:(RCTPromiseRejectBlock)reject)
{
  dispatch_async(dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:kOpenImmersiveSpace object:self userInfo:@{@"sceneId": sceneId}];
  });
}

@end
