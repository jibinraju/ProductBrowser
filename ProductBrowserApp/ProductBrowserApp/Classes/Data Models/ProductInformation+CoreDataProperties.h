//
//  ProductInformation+CoreDataProperties.h
//  ProductBrowserApp
//
//  Created by Jibin Raju on 13/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ProductInformation.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProductInformation (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *categoryname;
@property (nullable, nonatomic, retain) NSString *productdescription;
@property (nullable, nonatomic, retain) NSString *productimageurl;
@property (nullable, nonatomic, retain) NSNumber *itemsremaining;
@property (nullable, nonatomic, retain) NSString *productname;

@end

NS_ASSUME_NONNULL_END
