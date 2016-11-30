//
//  GFNetworkingAdapter.h
//  Pods
//
//  Created by huangjian on 16/11/17.
//
//

#import <Foundation/Foundation.h>
#import "GFNetworking.h"

#define kGFNetworkingExistURLSession NSClassFromString(@"NSURLSession")

@class GFNetworkingAdapterDataTask;

typedef void(^GFNetworkingSuccessBlock)(GFNetworkingAdapterDataTask *task, id responseObject);
typedef void(^GFNetworkingFailureBlock)(GFNetworkingAdapterDataTask *task, NSError *error);

@interface GFNetworkingAdapterDataTask : NSObject

@property (nonatomic, retain) NSURLRequest  * request;
@property (nonatomic, retain) NSURLResponse * response;

/* the parameter operationResult (optional) is used for upload task and download task.
 even if the network response is successful, but these tasks depend on the internal operation result.
 */
@property (nonatomic, assign) BOOL operationResult;

@end

@interface GFNetworkingAdapter : NSObject

@property (nonatomic, strong) GFHTTPRequestSerializer  <GFURLRequestSerialization>  * requestSerializer;
@property (nonatomic, strong) GFHTTPResponseSerializer <GFURLResponseSerialization> * responseSerializer;

+ (instancetype)manager;

- (GFNetworkingAdapterDataTask *)GET:(NSString *)URLString
                          parameters:(id)parameters
                             success:(GFNetworkingSuccessBlock)success
                             failure:(GFNetworkingFailureBlock)failure;

- (GFNetworkingAdapterDataTask *)POST:(NSString *)URLString
                           parameters:(id)parameters
                              success:(GFNetworkingSuccessBlock)success
                              failure:(GFNetworkingFailureBlock)failure;

- (GFNetworkingAdapterDataTask *)download:(NSString *)sourceString
                                   target:(NSString *)targetString
                                  success:(GFNetworkingSuccessBlock)success
                                  failure:(GFNetworkingFailureBlock)failure;

- (GFNetworkingAdapterDataTask *)upload:(NSURLRequest *)request
                                success:(GFNetworkingSuccessBlock)success
                                failure:(GFNetworkingFailureBlock)failure;

@end
