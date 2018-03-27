//
//  ProductInformationHandler.h
//  ProductBrowserApp
//
//  Created by Jibin Raju on 13/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//


/*
 * This class mainly work as a proxy between processor class and Coredata manager
 * It will iterate one by one products from json response and push into coredata as NSManagedObject.
 */

@interface ProductInformationHandler : NSObject

/*
 * Parse one by one product information and assigne that details to NSManagedObject
 * @parameter : productList, array of products.
 * @return type : BOOL, if parsing is faile it will return NO and log error.
 */
- (BOOL) parseProductList : (NSArray *) productList;

@end
