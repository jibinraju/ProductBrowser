//
//  NSString+MD5.h
//  ProductBrowserApp
//
//  Created by Jibin Raju on 12/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MD5)

/*
 * MD 5 Hash algoritham 
 * This algoritham's code snippet took from this website http://stackoverflow.com/questions/7264022/adding-md5-to-a-uitextfield
 */
- (NSString *)stringWithMD5Hash;

@end
