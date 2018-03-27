//
//  ProductsFetcherResponseProcessor.h
//  ProductBrowserApp
//
//  Created by Jibin Raju on 12/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "BaseResponseProcessor.h"

/*
 * This calss is inherited from BaseResponseProcessor, so this class has all capabilities of BaseResponseProcessor class.
 * Now this class has extra capability to parse the products from the server end and it will do few validations as well
 */

@interface ProductsFetcherResponseProcessor : BaseResponseProcessor

@property (nonatomic, copy) serviceResponseCallbackBlock serviceResponseBlck;

@end
