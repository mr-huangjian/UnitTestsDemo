//
//  GFNetworkingAdapter.m
//  Pods
//
//  Created by huangjian on 16/11/17.
//
//

#import "GFNetworkingAdapter.h"

@implementation GFNetworkingAdapterDataTask
@end

@interface GFNetworkingAdapter ()
{
    GFHTTPRequestOperationManager *global_connect_manager;
    
    GFHTTPSessionManager *global_session_manager;
}
@end

@implementation GFNetworkingAdapter

+ (instancetype)manager {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        if (kGFNetworkingExistURLSession) {
            NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            global_session_manager = [[GFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
        } else {
            global_connect_manager = [GFHTTPRequestOperationManager manager];
        }
    }
    return self;
}

- (void)setRequestSerializer:(GFHTTPRequestSerializer<GFURLRequestSerialization> *)requestSerializer {
    _requestSerializer = requestSerializer;
    
    if (kGFNetworkingExistURLSession) {
        global_session_manager.requestSerializer = _requestSerializer;
    } else {
        global_connect_manager.requestSerializer = _requestSerializer;
    }
}

- (void)setResponseSerializer:(GFHTTPResponseSerializer<GFURLResponseSerialization> *)responseSerializer {
    _responseSerializer = responseSerializer;
    
    if (kGFNetworkingExistURLSession) {
        global_session_manager.responseSerializer = _responseSerializer;
    } else {
        global_connect_manager.responseSerializer = _responseSerializer;
    }
}

- (GFNetworkingAdapterDataTask *)GET:(NSString *)URLString
                          parameters:(id)parameters
                             success:(GFNetworkingSuccessBlock)success
                             failure:(GFNetworkingFailureBlock)failure {
    
    GFNetworkingAdapterDataTask * dataTask = [[GFNetworkingAdapterDataTask alloc] init];
    
    if (kGFNetworkingExistURLSession) {
        NSURLSessionDataTask * tempTask = [global_session_manager GET:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            dataTask.response = task.response;
            success(dataTask, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            dataTask.response = task.response;
            failure(dataTask, error);
        }];
        
        dataTask.request = tempTask.originalRequest;
        
    } else {
        GFHTTPRequestOperation * tempOperation = [global_connect_manager GET:URLString parameters:parameters success:^(GFHTTPRequestOperation *operation, id responseObject) {
            dataTask.response = operation.response;
            success(dataTask, responseObject);
        } failure:^(GFHTTPRequestOperation *operation, NSError *error) {
            dataTask.response = operation.response;
            failure(dataTask, error);
        }];
        
        dataTask.request = tempOperation.request;
    }
    
    return dataTask;
}

- (GFNetworkingAdapterDataTask *)POST:(NSString *)URLString
                           parameters:(id)parameters
                              success:(GFNetworkingSuccessBlock)success
                              failure:(GFNetworkingFailureBlock)failure {
    
    GFNetworkingAdapterDataTask * dataTask = [[GFNetworkingAdapterDataTask alloc] init];
    
    if (kGFNetworkingExistURLSession) {
        NSURLSessionDataTask *tempTask = [global_session_manager POST:URLString parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
            dataTask.response = task.response;
            success(dataTask, responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            dataTask.response = task.response;
            failure(dataTask, error);
        }];
        
        dataTask.request = tempTask.originalRequest;
        
    } else {
        GFHTTPRequestOperation * tempOperation = [global_connect_manager POST:URLString parameters:parameters success:^(GFHTTPRequestOperation *operation, id responseObject) {
            dataTask.response = operation.response;
            success(dataTask, responseObject);
        } failure:^(GFHTTPRequestOperation *operation, NSError *error) {
            dataTask.response = operation.response;
            failure(dataTask, error);
        }];
        
        dataTask.request = tempOperation.request;
    }
    
    return dataTask;
}

- (GFNetworkingAdapterDataTask *)download:(NSString *)sourceString
                                   target:(NSString *)targetString
                                  success:(GFNetworkingSuccessBlock)success
                                  failure:(GFNetworkingFailureBlock)failure {
    
    GFNetworkingAdapterDataTask * dataTask = [[GFNetworkingAdapterDataTask alloc] init];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:sourceString]];
    
    if (kGFNetworkingExistURLSession) {
        
        NSURLSessionDownloadTask * task = [global_session_manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            return [NSURL fileURLWithPath:targetString];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            
            if (error) {
                dataTask.response = [[NSURLResponse alloc] init];
                failure(dataTask, error);
            } else {
                dataTask.operationResult = YES;
                dataTask.response = response;
                success(dataTask, nil);
            }
            
        }];
        
        [task resume];
        
        dataTask.request = task.originalRequest;
        
    } else {
        
        GFHTTPRequestOperation * operation = [[GFHTTPRequestOperation alloc] initWithRequest:request];
        
        [operation setCompletionBlockWithSuccess:^(GFHTTPRequestOperation *operation, id responseObject) {
            dataTask.operationResult = [responseObject writeToFile:targetString atomically:YES];
            dataTask.response = operation.response;
            success(dataTask, responseObject);
        } failure:^(GFHTTPRequestOperation *operation, NSError *error) {
            dataTask.response = operation.response;
            failure(dataTask, error);
        }];
        
        [operation start];
        
        dataTask.request = operation.request;
    }
    
    return dataTask;
}

- (GFNetworkingAdapterDataTask *)upload:(NSURLRequest *)request
                                success:(GFNetworkingSuccessBlock)success
                                failure:(GFNetworkingFailureBlock)failure {
    
    GFNetworkingAdapterDataTask * dataTask = [[GFNetworkingAdapterDataTask alloc] init];
    
    if (kGFNetworkingExistURLSession) {
        
        NSURLSessionUploadTask * task = [global_session_manager uploadTaskWithStreamedRequest:request progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                dataTask.response = [[NSURLResponse alloc] init];
                failure(dataTask, error);
            } else {
                dataTask.response = response;
                success(dataTask, responseObject);
            }
        }];
        
        [task resume];
        
        dataTask.request = task.originalRequest;
        
    } else {
        
        GFHTTPRequestOperation * operation = [global_connect_manager HTTPRequestOperationWithRequest:request success:^(GFHTTPRequestOperation *operation, id responseObject) {
            dataTask.response = operation.response;
            success(dataTask, responseObject);
        } failure:^(GFHTTPRequestOperation *operation, NSError *error) {
            dataTask.response = operation.response;
            failure(dataTask, error);
        }];
        
        [operation start];
        
        dataTask.request = operation.request;
    }
    
    return dataTask;
}



@end
