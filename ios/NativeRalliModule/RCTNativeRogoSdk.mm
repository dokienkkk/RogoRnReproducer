//
//  RCTNativeRogoSdk.m
//  RogoRNReproducer
//
//  Created by Do Kien on 10/11/25.
//

#import "RCTNativeRogoSdk.h"
#import "RCTDefaultReactNativeFactoryDelegate.h"
#import "ExpoModulesCore-Swift.h"
#import "Expo-Swift.h"
#import "RogoRNReproducer-Swift.h"

@implementation RCTNativeRogoSdk {
  RogoSdkImpl *rogoSdkImpl;
}

+ (NSString *)moduleName
{
  return @"NativeRogoSdk";
}

- (id) init {
  if (self = [super init]) {
    rogoSdkImpl = [RogoSdkImpl new];
  }
  return self;
}

- (std::shared_ptr<facebook::react::TurboModule>)getTurboModule:(const facebook::react::ObjCTurboModule::InitParams &)params { 
  return std::make_shared<facebook::react::NativeRogoSdkSpecJSI>(params);
}

- (void)signInWithToken:(nonnull NSString *)token resolve:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject { 
  return [rogoSdkImpl signInWithTokenWithToken:token resolve:resolve reject:reject];
}

- (nonnull NSNumber *)isAuthenticated {
  return @([rogoSdkImpl isAuthenticated]);
}

- (void)signOut:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject {
  return [rogoSdkImpl signOutWithResolve:resolve reject:reject];
}

- (nonnull NSArray<NSDictionary *> *)allLocations { 
  return [rogoSdkImpl allLocations];
}

- (void)createLocation:(nonnull NSString *)label desc:(nonnull NSString *)desc resolve:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject { 
  return [rogoSdkImpl createLocationWithLabel:label desc:desc resolve:resolve reject:reject];
}

- (nonnull NSString *)getAppLocation { 
  return [rogoSdkImpl getAppLocation];
}

- (void)setAppLocation:(nonnull NSString *)locationId {
  return [rogoSdkImpl stopScan];
}

- (void)refreshUserData:(nonnull RCTPromiseResolveBlock)resolve reject:(nonnull RCTPromiseRejectBlock)reject { 
  return [rogoSdkImpl refreshUserDataWithResolve:resolve reject:reject];
}

- (void)scanAvaiableWileDevice { 
  return [rogoSdkImpl scanAvaiableWileDevice];
}

- (void)stopScan { 
  return [rogoSdkImpl stopScan];
}

- (void)connectWifi:(nonnull NSString *)ssid pass:(nonnull NSString *)pass { 
  return [rogoSdkImpl connectWifiWithSsid:ssid pass:pass];
}


@end
