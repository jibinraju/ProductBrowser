//
//  Common_Utilities.h
//  ProductBrowserApp
//
//  Created by Jibin Raju on 12/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//


/*
 * All functions are static in this calss becuase all are generic functions. Wrappe the exisiting functionalities and provide extra characterise to it.
 * Most of class and API's from UIKit and UIFoundation frameworks.
 */

@interface Common_Utilities : NSObject

/*
 * Custom alter controller. Wrappe-up the exisitng UIAlterview in a static function and Make it easy to use and aviod the code duplication as well.
 * UIAlterContoller should be present from a UIController
 * @parameters : All parameters are self explanatory (if you have doubt please ref : https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIAlertController_class/index.html#//apple_ref/doc/uid/TP40014538-CH1-SW2)
 * return type : UIAlterViewController, success return new alterview object otherwise it will return 'nil'.
 */
+ (UIAlertController *) createAlertControllerWithTitle: (NSString *) title withMessage: (NSString *) message
                                    withPreferredStyle: (UIAlertControllerStyle) alterControllerStyle withCancelAction: (UIAlertAction *) cancelAction
                                          withOKAction: (UIAlertAction *) okAction;
/*
 * Below functions are lighter versions of above functions.
 * Both functions will display the AlertControllerStyle as UIAlertControllerStyleAlert.
 */
//Set Action as default Action
+ (UIAlertController *) createOKAlertControllerWithTitle: (NSString *) title withMessage: (NSString *) message
                              withAlterActionBlock:(alertActionBlock) okAlertActionBlck;

/*
 * Application Set below action as default
 *          OK = UIAlertActionStyleDefault
 *          Cancel = UIAlertActionStyleCancel
 */
+ (UIAlertController *) createOKCancelAlertWithTitle: (NSString *) title withMessage: (NSString *) message
                            withAlterCancelActionBlock:(alertActionBlock) cancelAlertActionBlck withAlterOKActionBlock:(alertActionBlock) okAlertActionBlck;

/*
 * Wrappper function for creating the alert action.
 */
+ (UIAlertAction *) createAlertActionWithTitle: (NSString *) actionTitle withActionStyle: (UIAlertActionStyle) actionStyle
                       withActionBlockHandler: (alertActionBlock) alertBlockHandler;

/*
 * This function will validate input string is empty or not. Its only doing logical validation based on few scenarios (like null, empty string, invalid object).
 * @parameter : NSString data type.
 * @return type : BOOL, if input string is empty then it will return 'YES' otherwise 'NO'.
 */
+ (BOOL) isEmptyString:(NSString *) inputStringForValidation;

/*
 * This function check the internet connection avaliablity in device and if you want to notify user about conectivity. you will get altercontroller in block.
 * @parameter : connectivityAlertViewBlck, to show the alertcontroller.
 * @return type : BOOL, YES for internet connectivity, NO for no connectivity.
 */
+ (BOOL) checkInternetIsAvaliable:(internetConnectivityAlterViewShowingBlock) connectivityAlertViewBlck;

/*
 * This function compose the local image storage path from the image URL. its using MD5 algorithm to make the path from url
 * @parameter : imageWebUrl, url of image.
 * @return type : NSString, return a new local path of device.
 */
+ (NSString *) imageCachePathForUrl:(NSString *)imageWebUrl;

@end
