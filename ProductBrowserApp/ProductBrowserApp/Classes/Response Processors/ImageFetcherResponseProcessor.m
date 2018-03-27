//
//  ImageFetcherResponseProcessor.m
//  ProductBrowserApp
//
//  Created by Jibin Raju on 12/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "ImageFetcherResponseProcessor.h"
#import "Common_Utilities.h"
#import "BaseService.h"

@implementation ImageFetcherResponseProcessor

- (void) dealloc {
    
    self.imageDwnloadResposeBlck = nil;
}

- (void)didFinishReceivingData {
    
    UIImage *receivedImage = nil;
    if (self.data ) {
    
        //NSData to image
        receivedImage = [[UIImage alloc] initWithData:self.data];
        DLog(@"Received Image Size %@",NSStringFromCGSize(receivedImage.size));
        //prepare local image path based on image url
        NSString *imagePath = [Common_Utilities imageCachePathForUrl:self.urlServiceSession.requestURL];
        if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath] == NO) {
            
            //Directory creation process if directory is not there
            NSString *directPath = [imagePath stringByDeletingLastPathComponent];
            BOOL directory = NO;
            if ([[NSFileManager defaultManager] fileExistsAtPath:directPath isDirectory:&directory] == NO) {
                
                NSError *error = nil;
                [[NSFileManager defaultManager] createDirectoryAtPath:directPath withIntermediateDirectories:NO attributes:nil error:&error];
                if (error) {
                    
                    DLog(@"Failed to create directory due to : %@",[error description]);
                }
            }
            
            [UIImageJPEGRepresentation(receivedImage, 1.0) writeToFile:imagePath atomically:YES];
        }
    }
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        //this callback is routing to the GUI level, so it should be in main thread
        if (_imageDwnloadResposeBlck) {
            
            _imageDwnloadResposeBlck(receivedImage, self.error, self.urlServiceSession.requestURL);
        }
    });
}

- (void)didFailReceivingDataWithError:(NSError *)error {
    
    //Triggering the success function becuase that function handle the failuer scenario as well.
    [self didFinishReceivingData];
}

@end
