//
//  ZPAutoDebitDelegete.h
//  zpdk
//
//  Created by Nguyen Van Nghia on 10/1/20.
//  Copyright © 2020 VNG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPPaymentErrorCode.h"

@protocol ZPConfirmAutoDebitDelegate <NSObject>
- (void)confirmAutoDebitDidSucceeded:(NSString *)bindingId;
@end
