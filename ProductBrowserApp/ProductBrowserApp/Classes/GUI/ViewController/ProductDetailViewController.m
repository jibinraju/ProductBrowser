//
//  ProductDetailViewController.m
//  ProductBrowserApp
//
//  Created by Jibin Raju on 13/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import "ProductDetailViewController.h"
#import "ProductInformation.h"
#import "ImageFetcherService.h"
#import "Common_Utilities.h"
#import "UIImage+resizing.h"

#define kImageViewSize CGSizeMake(584.0f, 350.0f)

@interface ProductDetailViewController() {
    
    IBOutlet UIImageView *productImageView;
    IBOutlet UILabel *productNameLbl;
    IBOutlet UIWebView *productDescriptionWebView;
    IBOutlet UIActivityIndicatorView *productImageLoadingActivityIndctr;
}

@property (nonatomic, strong) ImageFetcherService *imageFetcherService;
@property (nonatomic, strong) NSTimer *animationFunctionTriggeringTimer;

/*
 * initialize sub GUI controls with product information data
 * @parameter : NO Arguments
 * @return type : void.
 */
- (void) initializeSubGUIControlsWithValues;

/*
 * download product image from server end.
 * @parameters : NO arguments
 * @return type : void
 */
- (void) invokeProductImageDownload;

/*
 * animation effect on product name label, function using UIView Animation capabilities.
 * @parameters : NO arguments
 * @return type : void
 */
- (void) animationEffectOnProductName;

/*
 * animation effect on product image, function using UIView Animation capabilities.
 * @parameters : NO arguments
 * @return type : void
 */
- (void) scalingAnimationEffectOnProductImage;

@end

@implementation ProductDetailViewController

- (void) dealloc {
    
    [_imageFetcherService cancel];
    [_animationFunctionTriggeringTimer invalidate];
    self.animationFunctionTriggeringTimer = nil;
    self.imageFetcherService = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initializeSubGUIControlsWithValues];
    [self invokeProductImageDownload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private functions implementation

- (void) initializeSubGUIControlsWithValues {
  
    productNameLbl.text = _productInformation.productname;
    if ([Common_Utilities isEmptyString:_productInformation.productname] == NO) {
        
        self.animationFunctionTriggeringTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f target:self selector:@selector(animationEffectOnProductName)
                                                                               userInfo:nil repeats:YES];
        time_t randTime;
        srand((unsigned) time(&randTime));
    }
    
    //Product description formatted as html beucase some descriptions have html line break phrases
    NSString *htmlTemplatePath = [[NSBundle mainBundle] pathForResource:@"ProductDescriptionFormat" ofType:@"html"];
    NSString *htmlContent = [[NSString alloc] initWithContentsOfFile:htmlTemplatePath encoding:NSUTF8StringEncoding error:NULL];
    htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"$description$" withString:_productInformation.productdescription];
    DLog(@"HTML %@",htmlContent);
    [productDescriptionWebView loadHTMLString:htmlContent baseURL:nil];
}

- (void) invokeProductImageDownload {
    
    self.imageFetcherService = nil;
    if ([Common_Utilities isEmptyString:_productInformation.productimageurl] == NO) {
        
        self.imageFetcherService = [[ImageFetcherService alloc] init];
        _imageFetcherService.requestURL = _productInformation.productimageurl;
        [productImageLoadingActivityIndctr startAnimating];
        [_imageFetcherService downloadImageWithCallBackBlock:^(UIImage *responseData, NSError *error, NSString *imageURL) {
            
            if ([_productInformation.productimageurl isEqualToString:imageURL] == YES) {
                
                [productImageLoadingActivityIndctr stopAnimating];
                CGFloat scale = [UIScreen mainScreen].scale;
                productImageView.image = [responseData imageByAspectFillForSize: CGSizeMake((kImageViewSize.width * scale), (kImageViewSize.height*scale))];
                if (productImageView.image) {
                    
                 
                    [self performSelector:@selector(scalingAnimationEffectOnProductImage) withObject:nil afterDelay:0.1f];
                }
            }
        }];
    }
    else {
        
        [productImageLoadingActivityIndctr stopAnimating];
    }

}

- (void) animationEffectOnProductName {
    
    static int timerInvokeCount = 0;
    
    [UIView animateWithDuration:2.0 animations:^{
        
        if (timerInvokeCount % 2) {
            
            //font size changing logic
            UIFont *font = productNameLbl.font;
            UIFont *newFont = [UIFont fontWithName:font.fontName size:((CGFloat)(random()%40))];
            productNameLbl.font = newFont;
        }
        else {
            
            //Color changing logic
            productNameLbl.textColor = [UIColor colorWithRed:(((CGFloat)(random()%255))/255)
                                                       green:(((CGFloat)(random()%255))/255)
                                                        blue:(((CGFloat)(random()%255))/255)
                                                       alpha:1.0f];
        }
        
        
        
    }];
    
    ++timerInvokeCount;
}

- (void) scalingAnimationEffectOnProductImage {
    
    productImageView.transform = CGAffineTransformMakeScale(0.4f, 0.4f);
    //changin the image view transformation identity
    [UIView animateWithDuration:2.0f delay:0 options:UIViewAnimationOptionBeginFromCurrentState
                     animations:(void (^)(void)) ^ {
                         
                         productImageView.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
                     }
                     completion:^(BOOL finished) {
                         
                         productImageView.transform = CGAffineTransformIdentity;
                     }];
}

@end
