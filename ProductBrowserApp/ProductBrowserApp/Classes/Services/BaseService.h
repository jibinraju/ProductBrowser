//
//  BaseService.h
//  ProductBrowserApp
//
//  Created by Jibin Raju on 12/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//


//Foward deceleration
@class BaseResponseProcessor;

/*
 * This is base service class for webservice requests. its derived from the NSOperation for the concurrent.
 * Please refer below URL for more details and functionlity of NSOperation
 * https://developer.apple.com/library/mac/documentation/Cocoa/Reference/NSOperation_class/
 */

@interface BaseService : NSOperation 

@property (nonatomic, strong) NSURLSession *urlSession; //NSURLSession object which hold the current URL session configuration
@property (nonatomic, strong) BaseResponseProcessor *responseProcessor; //Response and error handler class object
@property (nonatomic, strong) NSString *requestURL; //Web service url
@property (nonatomic, strong) NSDictionary *HTTPHeaderFields; //Additional HTTP header fields
@property (nonatomic, strong) NSDictionary *bodyParameters; //Request parameters
@property (nonatomic, strong) NSString *methodType; //HTTP method type (E.g. GET, POST etc.)

/*
 * initializeSession function will create new NSURL session using default session configuration.
 * you can customise this function in child class and modify the session configuration accordingly.
 * @parameters : NO Arguments
 * @return type : BOOL, YES - successfull initialize the session configuration; NO - failed to initalize session due to any internal parameters.
 */
- (BOOL) initializeSession;


@end