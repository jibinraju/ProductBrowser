//
//  UIImage+resizing.h
//  ProductBrowserApp
//
//  Created by Jibin Raju on 13/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//


/*
 * Image resizing logic took from below URL
 * https://gist.github.com/davinc/8507fc60498dbcf052a7
 */

@interface UIImage (resizing)

- (UIImage*)imageWithSize:(CGSize)targetSize;
- (UIImage*)imageByAspectFillForSize:(CGSize)targetSize;

@end
