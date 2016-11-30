# GFNetworking

> 基于AFNetworking 2.5.0 对 iOS 6 及以上版本的网络请求服务的适配


## GFNetworkingAdapter


类```GFNetworkingAdapter```通过宏```kGFNetworkingExistURLSession```判断当前系统是否存在```NSURLSession``` ```(iOS >= 7)```, 

若存在网络请求由```GFHTTPSessionManager```创建，否则由```GFHTTPRequestOperationManager```创建。

开发者可以绕过类```GFNetworkingAdapter```自己创建网络服务，跟```AFNetworking```一样使用。


```ruby
/**
 * @param requestSerializer   请求数据的数据类型
 * @description 初始化时可不设置，默认为 [GFHTTPRequestSerializer serializer];
 */
@property (nonatomic, strong) GFHTTPRequestSerializer  <GFURLRequestSerialization>  * requestSerializer;

/**
 * @param responseSerializer  响应数据的数据类型
 * @description 初始化时可不设置，默认为 [GFJSONResponseSerializer serializer];
 */
@property (nonatomic, strong) GFHTTPResponseSerializer <GFURLResponseSerialization> * responseSerializer;
```

### POST

```ruby
- (GFNetworkingAdapterDataTask *)POST:(NSString *)URLString
                           parameters:(id)parameters
                              success:(GFNetworkingSuccessBlock)success
                              failure:(GFNetworkingFailureBlock)failure;
```

```ruby
self.adapter = [GFNetworkingAdapter manager];

GFNetworkingAdapterDataTask * dataTask = [self.adapter GET:urlString parameters:params success:^(GFNetworkingAdapterDataTask *task, id responseObject) {
        
    // response success ...   
        
} failure:^(GFNetworkingAdapterDataTask *task, NSError *error) {
      
    // response failure ...     
}];
```

### Download

```ruby
/**
 * @param sourceString  下载的远程地址
 * @param targetString  保存文件的位置
 */
- (GFNetworkingAdapterDataTask *)download:(NSString *)sourceString
                                   target:(NSString *)targetString
                                  success:(GFNetworkingSuccessBlock)success
                                  failure:(GFNetworkingFailureBlock)failure;
```

```ruby
self.adapter = [GFNetworkingAdapter manager];

GFNetworkingAdapterDataTask * dataTask = [self.adapter download:sourceString target:targetString success:^(GFNetworkingAdapterDataTask *task, id responseObject) {
        
    // response success ...   
    
    // 若系统版本小于7，responseObject回调为写入的数据
    // 若系统版本大于等于7，responseObject回调为nil.
    // 是否下载并写入成功，根据task.operationResult值判断
        
} failure:^(GFNetworkingAdapterDataTask *task, NSError *error) {
      
    // response failure ...     
}];
```

### Upload


```ruby
/**
 * @param request  上传请求
 */
- (GFNetworkingAdapterDataTask *)upload:(NSURLRequest *)request
                                success:(GFNetworkingSuccessBlock)success
                                failure:(GFNetworkingFailureBlock)failure;
```


```ruby
self.adapter = [GFNetworkingAdapter manager];

NSMutableURLRequest *request = [[GFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:UploadURLString parameters:params constructingBodyWithBlock:^(id<GFMultipartFormData> formData) {
    [formData appendPartWithFileURL:[NSURL fileURLWithPath:LocalFilePath] name:name fileName:fileName mimeType:mineType error:nil];
} error:nil];
    
for (id key in params.allKeys) {
    [request setValue:[params objectForKey:key]  forHTTPHeaderField:key];
}

GFNetworkingAdapterDataTask * dataTask = [self.adapter upload:request success:^(GFNetworkingAdapterDataTask *task, id responseObject) {
        
    // response success ...   
        
} failure:^(GFNetworkingAdapterDataTask *task, NSError *error) {
      
    // response failure ...     
}];
```






