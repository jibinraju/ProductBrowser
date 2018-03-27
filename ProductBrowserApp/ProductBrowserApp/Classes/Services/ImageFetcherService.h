//
//  ImageFetcherService.h
//  ProductBrowserApp
//
//  Created by Jibin Raju on 13/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "BaseService.h"


/*
 * This calss is inherited from BaseService, so this class has all capabilities of BaseService class.
 * Now this class has extra capability to fetch Images from the server end.
 */

@interface ImageFetcherService : BaseService

/*
 * This function fetch image from the server end and result will be get in callback block
 * function will compose the service request and get respon in call back block
 * @parameter : imageDownloaderCallbackBlck, this is a functions parameterized function block with UIImage and NSError.
 * @return type : void
 */
- (void) downloadImageWithCallBackBlock:(imageDownloaderResponseCallbackBlock) imageDownloaderCallbackBlck;

@end
