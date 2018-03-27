//
//  ProductListHeaderView.m
//  ProductBrowserApp
//
//  Created by Jibin Raju on 13/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "ProductListHeaderView.h"

@interface ProductListHeaderView() {
    
    IBOutlet UILabel *totalNumberOfItemsLbl;
    IBOutlet UILabel *lastUpdatedTimeStampLbl;
}


@end

@implementation ProductListHeaderView

- (void) setTotalNumberOfItems:(NSInteger)totalNumberOfItems {
    
    _totalNumberOfItems = totalNumberOfItems;
    totalNumberOfItemsLbl.text = [NSString stringWithFormat:@"%ld",(long)totalNumberOfItems];
}

- (void) setLastUpdatedTimeStamp:(NSString *)lastUpdatedTimeStamp {
    
    _lastUpdatedTimeStamp = lastUpdatedTimeStamp;
    lastUpdatedTimeStampLbl.text = lastUpdatedTimeStamp;
}

@end
