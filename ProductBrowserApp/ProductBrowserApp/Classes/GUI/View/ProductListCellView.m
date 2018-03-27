//
//  ProductListCellView.m
//  ProductBrowserApp
//
//  Created by Jibin Raju on 13/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "ProductListCellView.h"
#import "ProductInformation.h"
#import "ImageFetcherService.h"
#import "UIImage+resizing.h"
#import "Common_Utilities.h"

#define kImageViewSize CGSizeMake(64.0f, 64.0f)

@interface ProductListCellView() {
    
    IBOutlet UIImageView *productTumbnailImgView;
    IBOutlet UIActivityIndicatorView *productTumbnailImageLoadingActivityIndctr;
    IBOutlet UILabel *productName_CategoryLbl;
    IBOutlet UILabel *productItemRemainingCountLbl;
}

@property (nonatomic, strong) ImageFetcherService *imageFetcherService;

/*
 * invoke Image download service.
 * @parameters : NO arguments
 * @return type : void
 */
- (void) invokeImageDownload;

@end

@implementation ProductListCellView

- (void) dealloc {
    
    [self.imageFetcherService cancel];
    self.imageFetcherService = nil;
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    productItemRemainingCountLbl.text = @"";
    productName_CategoryLbl.text = @"";
    productTumbnailImgView.image = nil;
    [productTumbnailImageLoadingActivityIndctr stopAnimating];
}


- (void) setProductionInformation:(ProductInformation *)productionInformation {
    
    if (productionInformation) {
        
        _productionInformation = productionInformation;
        
        productItemRemainingCountLbl.text = [_productionInformation.itemsremaining stringValue];
        NSString *productNamenCategory = [NSString stringWithFormat:@"%@\n%@",_productionInformation.productname, _productionInformation.categoryname];
        productName_CategoryLbl.text = productNamenCategory;
        [self invokeImageDownload];
    }
}

#pragma mark - private functions implementation

- (void) invokeImageDownload {
    
    self.imageFetcherService = nil;
    if ([Common_Utilities isEmptyString:_productionInformation.productimageurl] == NO) {
        
        self.imageFetcherService = [[ImageFetcherService alloc] init];
        _imageFetcherService.requestURL = _productionInformation.productimageurl;
        [productTumbnailImageLoadingActivityIndctr startAnimating];
        [_imageFetcherService downloadImageWithCallBackBlock:^(UIImage *responseData, NSError *error, NSString *imageURL) {
            
            if ([_productionInformation.productimageurl isEqualToString:imageURL] == YES) {
                
                [productTumbnailImageLoadingActivityIndctr stopAnimating];
                CGFloat scale = [UIScreen mainScreen].scale;
                productTumbnailImgView.image = [responseData imageWithSize:CGSizeMake((kImageViewSize.width * scale), (kImageViewSize.height*scale))];
            }
        }];
    }
    else {
        
        [productTumbnailImageLoadingActivityIndctr stopAnimating];
    }
    
}

@end
