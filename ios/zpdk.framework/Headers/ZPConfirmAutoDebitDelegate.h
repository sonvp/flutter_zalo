//
//  ZPAutoDebitDelegete.h
//  zpdk
//
//  Created by Nguyen Van Nghia on 10/1/20.
//  Copyright © 2020 VNG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPPaymentErrorCode.h"

typedef NS_ENUM(NSInteger, ZPBindingErrorCode) {
    ZPBinding_Success         = 1,
    ZPBinding_Fail            = 0,
    ZPBinding_AppNotInstall   = -1,
};

@protocol ZPConfirmAutoDebitDelegate <NSObject>
- (void)bindingSucces:(NSString * _Nonnull)bindingId extra:(NSDictionary * _Nonnull)extra;
- (void)bindingFail:(NSString * _Nonnull)bindingId error:(ZPBindingErrorCode)code extra:(NSDictionary * _Nonnull)extra;
@end
