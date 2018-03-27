//
//  ServiceOperationQueue.h
//  ProductBrowserApp
//
//  Created by Jibin Raju on 12/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

/*
 * This is child class of NSOperationQueue and all operations will be add to this queue base on priority / sequence task will performed.
 */

/*
 
 Operation queue process flow; this is a FIFO queue
    ------------------------------------------------------------------------------------------------
    | Network Service Task | Network Service Task | Network Service Task | Network Service Task |
    ------------------------------------------------------------------------------------------------
 
 for more details please ref : https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperationQueue_class/
 
 */


@interface ServiceOperationQueue : NSOperationQueue

/*
 * This is a singleton class, so any modules can access it quickly and add network operations.
 * @parameters : NO Arguments
 * @return type : ServiceOperationQueue's static object.
 */
+ (instancetype) sharedInstance;

@end
