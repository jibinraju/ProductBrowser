//
//  ImageFetcherService.m
//  ProductBrowserApp
//
//  Created by Jibin Raju on 13/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "ImageFetcherService.h"
#import "Common_Utilities.h"
#import "ImageFetcherResponseProcessor.h"
#import "ServiceOperationQueue.h"

@implementation ImageFetcherService

- (instancetype) init {
    
    if ((self = [super init])) {
        
        [self initializeSession];
    }
    return self;
}

- (void) downloadImageWithCallBackBlock:(imageDownloaderResponseCallbackBlock) imageDownloaderCallbackBlck {
    
    //Loading the image from local cache
    if ([Common_Utilities isEmptyString:self.requestURL] == NO) {
        
        //prepare local image path based on image url
        NSString *imagePath = [Common_Utilities imageCachePathForUrl:self.requestURL];
        if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath] == YES) {
            
            UIImage *imageFromCache = [UIImage imageWithContentsOfFile:imagePath];
            if (imageFromCache && imageDownloaderCallbackBlck) {
                
                imageDownloaderCallbackBlck(imageFromCache, nil, self.requestURL);
                return;
            }
        }
        
        ImageFetcherResponseProcessor *imageFetcherRspProc = [[ImageFetcherResponseProcessor alloc] init];
        imageFetcherRspProc.imageDwnloadResposeBlck = imageDownloaderCallbackBlck;
        
        self.methodType = @"GET";
        self.responseProcessor = imageFetcherRspProc;
        
        [[ServiceOperationQueue sharedInstance] addOperation:self];
    }
    else if (imageDownloaderCallbackBlck) {
       
        NSError *error = [NSError errorWithDomain:@"empty url" code:0 userInfo:nil];
        imageDownloaderCallbackBlck(nil, error, self.requestURL);
    }
}

@end
