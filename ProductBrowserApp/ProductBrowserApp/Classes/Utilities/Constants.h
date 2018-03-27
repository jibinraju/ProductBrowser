//
//  Constants.h
//  ProductBrowserApp
//
//  Created by Jibin Raju on 12/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//


//Foward deceleration
@class BaseResponseProcessor;

#pragma mark - numberic constants
static const double kDefaultRequestTimeOutValue =90.0f;


#pragma mark - typedef blocks
typedef void (^alertActionBlock) (UIAlertAction *action); //alter button touch call back block
typedef void (^serviceResponseCallbackBlock) (id responseData, NSError *error); //Service response from the server end
typedef void (^internetConnectivityAlterViewShowingBlock) (UIAlertController * alertController);
typedef void (^imageDownloaderResponseCallbackBlock) (UIImage *responseData, NSError *error, NSString *imageURL); //image response from the server end


#pragma mark - string constants
UIKIT_EXTERN NSString *kOK;
UIKIT_EXTERN NSString *kCancel;
UIKIT_EXTERN NSString *kProductServiceURL;


