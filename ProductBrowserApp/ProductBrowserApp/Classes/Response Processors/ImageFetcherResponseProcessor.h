//
//  ImageFetcherResponseProcessor.h
//  ProductBrowserApp
//
//  Created by Jibin Raju on 12/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "BaseResponseProcessor.h"

@interface ImageFetcherResponseProcessor : BaseResponseProcessor

@property (nonatomic, copy) imageDownloaderResponseCallbackBlock imageDwnloadResposeBlck;

@end
