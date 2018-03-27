//
//  ProductsFetcherService.m
//  ProductBrowserApp
//
//  Created by Jibin Raju on 12/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "ProductsFetcherService.h"
#import "ProductsFetcherResponseProcessor.h"
#import "ServiceOperationQueue.h"

@implementation ProductsFetcherService

- (instancetype) init {
    
    if ((self = [super init])) {
        
        [self initializeSession];
    }
    return self;
}

- (void) getProductsWithCallBackBlock:(serviceResponseCallbackBlock) serviceResponseBlck {
    
    
    ProductsFetcherResponseProcessor *productFetcherRspPrc = [[ProductsFetcherResponseProcessor alloc] init];
    productFetcherRspPrc.serviceResponseBlck = serviceResponseBlck;
    
    self.requestURL = kProductServiceURL;
    self.methodType = @"GET";
    self.responseProcessor = productFetcherRspPrc;
    self.queuePriority = NSOperationQueuePriorityVeryHigh;
    
    [[ServiceOperationQueue sharedInstance] addOperation:self];
}

@end
