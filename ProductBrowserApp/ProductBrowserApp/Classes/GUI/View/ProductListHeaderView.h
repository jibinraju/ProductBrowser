//
//  ProductListHeaderView.h
//  ProductBrowserApp
//
//  Created by Jibin Raju on 13/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductListHeaderView : UIView

@property (nonatomic, assign) NSInteger totalNumberOfItems; //total number of items displayed in list
@property (nonatomic, strong) NSString *lastUpdatedTimeStamp; //last update recived timestamp

@end
