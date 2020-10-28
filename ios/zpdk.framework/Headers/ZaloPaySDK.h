//
//  ZaloPaySDK.h
//  zpdk
//
//  Created by bonnpv on 11/30/16.
//  Copyright © 2016 VNG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZPZPIEnvironment.h"
#import "ZPPaymentDelegate.h"
#import "ZPConfirmAutoDebitDelegate.h"

@interface ZaloPaySDK : NSObject

@property (nonatomic, weak) id<ZPPaymentDelegate> paymentDelegate;
@property (nonatomic, weak) id<ZPConfirmAutoDebitDelegate> confirmAutoDebitDelegate;

+ (instancetype)sharedInstance;

- (void)initWithAppId:(NSInteger)appId;

- (void)initWithAppId:(NSInteger)appId
           environment:(ZPZPIEnvironment)environment;

- (void)initWithAppId:(NSInteger)appId
            uriScheme:(NSString*)uriScheme;

- (void)initWithAppId:(NSInteger)appId
            uriScheme:(NSString*)uriScheme
          environment:(ZPZPIEnvironment)environment;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;

- (void)payOrder:(NSString *)zptranstoken;

- (void)confirmAutoDebit:(NSString *)token;

- (void)navigateToZaloStore;
@end
