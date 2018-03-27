//
//  BaseDataResponseProcessor.m
//  ProductBrowserApp
//
//  Created by Jibin Raju on 12/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "BaseResponseProcessor.h"

@interface BaseResponseProcessor() {
}

@property (nonatomic, strong)  NSMutableData *data; //Private property for data appending process.

@end

@implementation BaseResponseProcessor

- (instancetype) init {
    
    if ((self = [super init])) {
     
        _receivedDataLength = 0;
    }
    return  self;
}

- (void) dealloc {
    
    self.data = nil;
    self.urlServiceSession = nil;
    self.error = nil;
}

- (void)didReceiveData:(NSData*)data {
    
    if (_data == nil) {
        
        self.data = [NSMutableData new];
    }
    
    [_data appendData:data];
}

- (void)didFinishReceivingData {
    
    DLog(@"Total Data Length : %lld",_receivedDataLength);
    DLog(@"Received Data : %@", self.data);
}

- (void)didFailReceivingDataWithError:(NSError *)error {
    
    self.error = error;
    DLog(@"Network request has failed due to error: %@",[error description]);
}

@end
