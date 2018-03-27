//
//  BaseDataResponseProcessor.h
//  ProductBrowserApp
//
//  Created by Jibin Raju on 12/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//


@class BaseService;

/*
 * This is base response processor class for response parsing. its derived from the NSObject.
 * it will receive all change notifications from the BaseService class
 */

@interface BaseResponseProcessor : NSObject

@property (nonatomic, readonly) NSMutableData *data; // Received data
@property (nonatomic, strong) NSError *error; // error is nil if the request completes with success, else holds an error that occured during the process.
@property (nonatomic, assign) int64_t receivedDataLength; // total received data length
@property (nonatomic, weak) BaseService *urlServiceSession; //Current service object

/*
 * To process any partial/full data. it will append data into the local mutable data object
 * @parameters : data, recevied from the server end
 * @return type : void.
 */
- (void)didReceiveData:(NSData*)data;
/*
 * To notify that the receiving process is complete, whole data is now ready to be processed if necessary.
 * @parameters : NO arguments
 * @return type : void.
 */
- (void)didFinishReceivingData;
/*
 * To notify that request  or session initialization has failed
 * @parameters : NO arguments
 * @return type : void.
 */
- (void)didFailReceivingDataWithError:(NSError *)error;



@end
