//
//  ProductsFetcherService.h
//  ProductBrowserApp
//
//  Created by Jibin Raju on 12/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "BaseService.h"

/*
 * This calss is inherited from BaseService, so this class has all capabilities of BaseService class.
 * Now this class has extra capability to fetch products from the server end.
 */

@interface ProductsFetcherService : BaseService

/*
 * This function fetch products from the server end and result will be get in callback block
 * function will compose the service request and get respon in call back block
 * @parameter : serviceResponseBlck, this is a functions block parameter and it will provide dynamic data type (id) and NSError.
 * @return type : void
 */
- (void) getProductsWithCallBackBlock:(serviceResponseCallbackBlock) serviceResponseBlck;

@end
