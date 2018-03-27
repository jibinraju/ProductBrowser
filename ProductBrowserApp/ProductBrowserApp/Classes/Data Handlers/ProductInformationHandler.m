//
//  ProductInformationHandler.m
//  ProductBrowserApp
//
//  Created by Jibin Raju on 13/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "ProductInformationHandler.h"
#import "CoreDataManager.h"
#import "ProductInformation.h"
#import "Common_Utilities.h"

//product Dictionary keys
static NSString *kProductCategoryName = @"category";
static NSString *kProductDescription = @"description";
static NSString *kProductImageUrl = @"image_url";
static NSString *kProductItemsRemaniningCount = @"items_remaining";
static NSString *kProductName = @"name";

@interface ProductInformationHandler()

/*
 * Function segregate required product information from the input dictionary and that information will assigned to managed object
 * @parameter : productKeyValueInfo, Key N Value of product information.
 * @return type : BOOL, return NO if any kind of error occured with input data.
 */
- (BOOL) parseProduct: (NSDictionary *) productKeyValueInfo;

@end

@implementation ProductInformationHandler

- (BOOL) parseProductList : (NSArray *) productList {
    
    BOOL returnStatus = NO;
    
    if (productList && productList.count > 0) {
        
        
        for (NSDictionary *productInformation in productList) {
            
            returnStatus |= [self parseProduct:productInformation];
        }
    }
    
    if (returnStatus == YES) {
        
        [[CoreDataManager sharedInstance] saveContext];
    }
    
    return returnStatus;
}

#pragma mark - private function implementation

- (BOOL) parseProduct: (NSDictionary *) productKeyValueInfo {
    
    BOOL returnStatus = NO;
    
    if (productKeyValueInfo.count > 0) {
        
        NSString *producName = [productKeyValueInfo objectForKey:kProductName];
        //Search for exisiting product, if we find existing product we will update the same. otherwise create new managed object and assign
        //vaules. Considering product name as primar key if there is no product key this function will discard the creation of managed object
        ProductInformation *productInformation = (ProductInformation *)[[CoreDataManager sharedInstance] searchProductName:producName];
        if (productInformation == nil) {
            
            if ([Common_Utilities isEmptyString:producName] == NO) {
                
                productInformation = (ProductInformation *)[[CoreDataManager sharedInstance] createProductInformationEntity];
            }
            else {
                
                DLog(@"ProductKeyValueInformation containts invalid values\n%@",productKeyValueInfo);
                return returnStatus;
            }
        }
        

        if (productInformation) {
            
            productInformation.productname = producName;
            productInformation.categoryname = [productKeyValueInfo objectForKey:kProductCategoryName];
            productInformation.productdescription = [productKeyValueInfo objectForKey:kProductDescription];
            productInformation.productimageurl = [productKeyValueInfo objectForKey:kProductImageUrl];
            NSNumber *itemRemainingCount = [productKeyValueInfo objectForKey:kProductItemsRemaniningCount];
            if ([itemRemainingCount isKindOfClass:[NSNumber class]] == YES) {
               
                productInformation.itemsremaining = [NSNumber numberWithInteger:[itemRemainingCount integerValue]];
            }
            else {
                
                DLog(@"Invalid data type in ProductKeyValueInfo\n%@",productInformation);
            }
            returnStatus = YES;
        }
    }
    
    return returnStatus;
}

@end
