//
//  BaseService.m
//  ProductBrowserApp
//
//  Created by Jibin Raju on 12/01/16.
//  Copyright © 2016 Sogeti B.V. All rights reserved.
//

// For more understanding about NSURLSession please refe : http://hayageek.com/ios-nsurlsession-example/

#import "BaseService.h"
#import "Common_Utilities.h"
#import "BaseResponseProcessor.h"


@interface BaseService()<NSURLSessionDataDelegate> {
    
    BOOL executing;
    BOOL finished;
}

@property (nonatomic, strong) NSURLSessionDataTask *urlSessionDataTask; //URL session task initiate the service communication layer.

/*
 * Managing the run loop excution and keep the operation task active untill its get respone from the server end.
 */
- (void)notifyStart;
- (void)notifyFinish;
/*
 * Prepare URL reqest with arguments and this URL request send to the server end.
 * @parameters
 *             urlPath : web service URL
 *             methodType : this Request-URI type ("GET" / "POST" ref: http://www.w3schools.com/tags/ref_httpmethods.asp for more information).
 *             requestBody : web request parameters sending along with the URL request.
 *             HTTPheaders : If need any kind of additional Http headers you can pass in this arugment.
 *
 * @return type: NSMutableURLRequest, if everything is success otherwise it will return 'nil' value.
 */
-(NSMutableURLRequest *) prepareRequestWithURLPath:(NSString *)urlPath methodType:(NSString *)methodType
                                       requestBody:(NSDictionary *)parameters HTTPheaders:(NSDictionary *)headers;

@end

@implementation BaseService


- (void)dealloc {
    
    _urlSessionDataTask = nil;
    _urlSession = nil;
    _requestURL = nil;
    _responseProcessor = nil;
    _HTTPHeaderFields = nil;
    _methodType = nil;
    _bodyParameters = nil;
}

- (BOOL) initializeSession {
    
    BOOL returnStatus = NO;
    if (_urlSession == nil) {
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        if (configuration) {
        
            configuration.HTTPShouldSetCookies = YES;
            configuration.HTTPShouldUsePipelining = NO;
            
            configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
            configuration.allowsCellularAccess = YES;
            configuration.timeoutIntervalForRequest = kDefaultRequestTimeOutValue;
            
            self.urlSession = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
            if (_urlSession) {
                
                returnStatus = YES;
            }
            else {
                
                DLog(@"Failed to create NSURLSession");
            }
        }
        else {
            
            DLog(@"Failed to create NSURLSessionConfiguration");
        }
    }
    else {
        
        returnStatus = YES;
    }
    
    return returnStatus;
}


- (void)start {
    
    @autoreleasepool {
        
        [self notifyStart];
        
        NSMutableURLRequest *URLrequest = [self prepareRequestWithURLPath:_requestURL methodType:_methodType
                                                           requestBody:_bodyParameters HTTPheaders:_HTTPHeaderFields];
        
        if (URLrequest) {
            
            self.urlSessionDataTask = [_urlSession dataTaskWithRequest:URLrequest];
            [_urlSessionDataTask resume];
            
            if (_urlSessionDataTask) {
                
                do {
                    
                    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
                } while (executing);
            }
        }
        else {
            
            DLog(@"Failed to create URL request");
        }
        
    }
}

//Below functions are override from the NSOperation

- (BOOL) isAsynchronous {
    
    return YES;
}

- (BOOL)isExecuting {
    
    return executing;
}

- (BOOL)isFinished {
    
    return finished;
}

- (void) cancel {
    
    [_urlSessionDataTask cancel];
    [self notifyFinish];
    [super cancel];
}


#pragma mark - private methods

-(NSMutableURLRequest *) prepareRequestWithURLPath:(NSString *)urlPath methodType:(NSString *)methodType requestBody:(NSDictionary *)parameters
                                       HTTPheaders:(NSDictionary *)headers {
    
    NSMutableURLRequest *urlRequest = nil;
    
    if ([Common_Utilities isEmptyString:urlPath] == NO && [Common_Utilities isEmptyString:methodType] == NO) {
        
        NSURLComponents *components = [NSURLComponents componentsWithString:urlPath];
        
        urlRequest = [NSMutableURLRequest requestWithURL:[components URL]];
        [urlRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) { //synchronous traversals
            
            NSString *keyString = (NSString *)key;
            NSString *headerValue = (NSString *)obj;
            [urlRequest addValue:headerValue forHTTPHeaderField:keyString];
        }];

        if (parameters && parameters.count > 0) {
            
            NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
            [urlRequest setHTTPBody:postData];
        }
        
        [urlRequest setHTTPMethod:methodType];
        [urlRequest setTimeoutInterval:kDefaultRequestTimeOutValue];
        
        //Debug logs
        DLog(@"Request URL : %@",[urlRequest.URL absoluteString]);
        
        if (urlRequest.allHTTPHeaderFields.count > 0) {
            
          DLog(@"Headers : %@",[urlRequest allHTTPHeaderFields]);
        }
        
        if (urlRequest.HTTPBody.length > 0) {
            
            DLog(@"Request Data : %@", [[NSString alloc] initWithData:urlRequest.HTTPBody  encoding:NSUTF8StringEncoding]);
        }
    }
    else {
        
        DLog(@"URL path or methodType is null, please check the request initialization class");
    }
    
    return urlRequest;
}

- (void)notifyStart {
    
    executing = YES;
    finished = NO;
}

- (void)notifyFinish  {
    
    executing = NO;
    finished  = YES;
}

#pragma mark - NSURLSessionDelegate implementation

- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    
    if (_responseProcessor) {
        
        _responseProcessor.urlServiceSession = self;
        [_responseProcessor didFailReceivingDataWithError:error];
    }
    
    [self notifyFinish];
}

//Callback for handle SSL authentication challenge
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)protectionSpace
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler {
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = [NSURLCredential credentialForTrust:protectionSpace.protectionSpace.serverTrust];
    if (completionHandler) {
        
        completionHandler(disposition, credential);
    }
}

#pragma mark - NSURLSessionTaskDelegate implementation

//Callback for handle SSL authentication challenge
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler {
    
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    __block NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];;
    
    if (completionHandler) {
        
        completionHandler(disposition, credential);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {

    NSURLSessionResponseDisposition disposition = NSURLSessionResponseAllow;
    
    if (completionHandler) {
        
        completionHandler(disposition);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    if (_responseProcessor) {
        
        _responseProcessor.urlServiceSession = self;
        _responseProcessor.receivedDataLength = dataTask.countOfBytesReceived;
        [_responseProcessor didReceiveData:data];
    }
    
    [self notifyFinish];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    
    if (_responseProcessor) {
        
        _responseProcessor.urlServiceSession = self;
        _responseProcessor.receivedDataLength = task.countOfBytesReceived;
        if (error) {
            
          [_responseProcessor didFailReceivingDataWithError:error];
        }
        else {
            
            [_responseProcessor didFinishReceivingData];
        }
    }
    
   [self notifyFinish];
}

@end

