//
//  Common_Utilities.m
//  ProductBrowserApp
//
//  Created by Jibin Raju on 12/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "Common_Utilities.h"
#import "Reachability.h"
#import "NSString+MD5.h"

@implementation Common_Utilities


+ (UIAlertController *) createAlertControllerWithTitle: (NSString *) title withMessage: (NSString *) message
                                    withPreferredStyle: (UIAlertControllerStyle) alterControllerStyle withCancelAction: (UIAlertAction *) cancelAction
                                          withOKAction: (UIAlertAction *) okAction {
    
    //Creating the AlterController
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:alterControllerStyle];
    //Add cancel action object
    if (cancelAction) {
        
        [alert addAction:cancelAction];
    }
    
    //Add ok action object
    if (okAction) {
        
        [alert addAction:okAction];
    }
    
    return alert;
}

+ (UIAlertController *) createOKAlertControllerWithTitle: (NSString *) title withMessage: (NSString *) message
                              withAlterActionBlock:(alertActionBlock) okAlertActionBlck {
    
    //OK Alert Action
    UIAlertAction *alertAction = [Common_Utilities createAlertActionWithTitle: kOK withActionStyle: UIAlertActionStyleDefault
                                                      withActionBlockHandler: okAlertActionBlck];
    
    return  [Common_Utilities createAlertControllerWithTitle:title withMessage:message withPreferredStyle:UIAlertControllerStyleAlert
                                            withCancelAction:nil withOKAction:alertAction];
}

+ (UIAlertController *) createOKCancelAlertWithTitle: (NSString *) title withMessage: (NSString *) message
                  withAlterCancelActionBlock:(alertActionBlock) cancelAlertActionBlck withAlterOKActionBlock:(alertActionBlock) okAlertActionBlck {
    
    //OK Alert Action
    UIAlertAction *alertOKAction = [Common_Utilities createAlertActionWithTitle: kOK withActionStyle: UIAlertActionStyleDefault
                                                      withActionBlockHandler: okAlertActionBlck];
    
    //Cancel Alert Action
    UIAlertAction *alertCancelAction = [Common_Utilities createAlertActionWithTitle: kCancel withActionStyle: UIAlertActionStyleCancel
                                                         withActionBlockHandler: cancelAlertActionBlck];
    
    return  [Common_Utilities createAlertControllerWithTitle:title withMessage:message withPreferredStyle:UIAlertControllerStyleAlert
                                            withCancelAction:alertCancelAction withOKAction:alertOKAction];
    
}

+ (UIAlertAction *) createAlertActionWithTitle: (NSString *) actionTitle withActionStyle: (UIAlertActionStyle) actionStyle
                       withActionBlockHandler: (alertActionBlock) alertBlockHandler {
    
    UIAlertAction* alertAction = nil;
    if (alertBlockHandler) {
    
        alertAction = [UIAlertAction actionWithTitle:actionTitle style:actionStyle
                                                          handler:alertBlockHandler];
    }
    
    return alertAction;
}

+ (BOOL) isEmptyString:(NSString *) inputStringForValidation {
    
    BOOL returnStatus = NO;
    if (inputStringForValidation == nil ||
        [inputStringForValidation isKindOfClass:[NSString class]] == NO ||
        inputStringForValidation.length <= 0) {
        
        returnStatus = YES;
    }
    return returnStatus;
}

+ (BOOL) checkInternetIsAvaliable:(internetConnectivityAlterViewShowingBlock) connectivityAlertViewBlck {
    
    BOOL returnStatus = YES;
    Reachability *internet = [Reachability reachabilityForInternetConnection];
    if ([internet currentReachabilityStatus] == NotReachable) {
        
        returnStatus = NO;
        if (connectivityAlertViewBlck) {
            
            UIAlertController *alertController = [Common_Utilities createOKAlertControllerWithTitle:nil
                                                    withMessage:@"You're not connected to Internet." withAlterActionBlock:^(UIAlertAction *action) {}];
            
            connectivityAlertViewBlck(alertController);
        }
    }
    return returnStatus;
}

+ (NSString *) imageCachePathForUrl:(NSString *)imageWebUrl {
    
    NSString *imagePath = nil;
    if ([Common_Utilities isEmptyString:imageWebUrl] == NO) {
        
        NSString *pathURL = [imageWebUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *componentPath = [NSString stringWithFormat:@"ImageCache/%@.jpg", [pathURL stringWithMD5Hash]];
        imagePath = [documentsPath stringByAppendingPathComponent:componentPath];
    }
    
    return  imagePath;
}

@end
