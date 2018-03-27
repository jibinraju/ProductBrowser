//
//  ServiceOperationQueue.m
//  ProductBrowserApp
//
//  Created by Jibin Raju on 12/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "ServiceOperationQueue.h"

@implementation ServiceOperationQueue

+ (instancetype) sharedInstance {
    
    static ServiceOperationQueue *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype) init {
    
    if ((self = [super init])) {
        
        [self setMaxConcurrentOperationCount: NSOperationQueueDefaultMaxConcurrentOperationCount]; //Operation count set as default value
        [self setName:@"com.productBrowserApp.WebServiceQueue"]; //Queue name
    }
    
    return self;
}

- (void) dealloc {
    
    [self cancelAllOperations];
}

- (void) cancelAllOperations {
    
    [super cancelAllOperations];
    [self waitUntilAllOperationsAreFinished];
}

@end
