/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

#import <React/RCTEventEmitter.h>

extern NSString *const RCTRemoteNotificationReceived;

@interface RCTPushNotificationManager : RCTEventEmitter

typedef void (^RCTRemoteNotificationCallback)(UIBackgroundFetchResult result);

#if !TARGET_OS_UIKITFORMAC
+ (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
+ (void)didReceiveRemoteNotification:(NSDictionary *)notification;
+ (void)didReceiveRemoteNotification:(NSDictionary *)notification
              fetchCompletionHandler:(RCTRemoteNotificationCallback)completionHandler;
#if !TARGET_OS_VISION
/** DEPRECATED. Use didReceiveNotification instead. */
+ (void)didReceiveLocalNotification:(UILocalNotification *)notification RCT_DEPRECATED;
#endif
/** DEPRECATED. Use didReceiveNotification instead. */
+ (void)didReceiveRemoteNotification:(NSDictionary *)notification RCT_DEPRECATED;

@end
