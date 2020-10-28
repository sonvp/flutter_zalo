//
//  ZaloPaySDKDelegate.h
//  zpdk
//
//  Created by bonnpv on 11/30/16.
//  Copyright © 2016 VNG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPPaymentErrorCode.h"

@protocol ZPPaymentDelegate <NSObject>

- (void)paymentDidSucceeded:(NSString *)transactionId
                 zpTranstoken:(NSString *)zpTranstoken
                   appTransId:(NSString *)appTransId;

- (void)paymentDidCanceled:(NSString *)zpTranstoken
                appTransId:(NSString *)appTransId;

- (void)paymentDidError:(ZPPaymentErrorCode)errorCode
           zpTranstoken:(NSString *)zpTranstoken
              appTransId:(NSString *)appTransId;

@end
