//
//  ProductsFetcherResponseProcessor.m
//  ProductBrowserApp
//
//  Created by Jibin Raju on 12/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "ProductsFetcherResponseProcessor.h"
#import "ProductInformationHandler.h"

@implementation ProductsFetcherResponseProcessor

- (void) dealloc {
    
    self.serviceResponseBlck = nil;
}

- (void)didFinishReceivingData {
    
    id parsedJsonObj = nil;
    if (self.data ) {
        
        parsedJsonObj = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableLeaves error:nil];
        if ([NSJSONSerialization isValidJSONObject:parsedJsonObj] == YES) {
            
            DLog(@"Data Converted to %@",parsedJsonObj);
            
            if ([parsedJsonObj isKindOfClass:[NSArray class]] == YES) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //inside this block is performing core data opertion and core data module which using in the application is not concurrence
                    //extended becuase of that putting that operation in main queue
                    ProductInformationHandler *productInformationHandler = [ProductInformationHandler new];
                    [productInformationHandler parseProductList:(NSArray *)parsedJsonObj];

                });
            }
        }
        else {
            
            DLog(@"invalid json response from the server end");
        }
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        //this callback is routing to the GUI level, so it should be in main thread
        if (_serviceResponseBlck) {
            
            _serviceResponseBlck(parsedJsonObj, self.error);
        }
    });
}

- (void)didFailReceivingDataWithError:(NSError *)error {
    
    //Triggering the success function becuase that function handle the failuer scenario as well.
    [self didFinishReceivingData];
}

@end
