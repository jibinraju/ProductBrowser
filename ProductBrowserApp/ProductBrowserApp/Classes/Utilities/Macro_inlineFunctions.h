//
//  Macro_inlineFunctions.h
//  ProductBrowserApp
//
//  Created by Jibin Raju on 12/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

/*
 * Here we can declare inline functions, macros and macro functions.
 * This file is mix of C and Object-C functions.
 */


#ifndef Macro_inlineFunctions_h
#define Macro_inlineFunctions_h


/*
 * Logging mechanism, its configured to work in debug enviroment.
 */
#ifdef DEBUG
#   define DLog(fmt, ...) {NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);}
#else
#   define DLog(...)
#endif

#endif /* Macro_inlineFunctions_h */
