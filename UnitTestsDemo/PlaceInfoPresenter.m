//
//  PlaceInfoPresenter.m
//  UnitTestsDemo
//
//  Created by huangjian on 16/12/1.
//  Copyright © 2016年 bojoy. All rights reserved.
//

#import "PlaceInfoPresenter.h"
#import "GFNetworking.h"

@implementation PlaceInfoPresenter

- (instancetype)initWithView:(id<PlaceInfoViewProtocol>)view {
    if (self = [super init]) {
        self.view = view;
    }
    return self;
}

- (void)loadData:(NSString *)placeName {
    
    GFNetworkingAdapter * adapter = [GFNetworkingAdapter manager];
    [adapter.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    adapter.responseSerializer = [GFJSONResponseSerializer serializer];
    adapter.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    
    NSString * URLString  = @"http://gc.ditu.aliyun.com/geocoding";
    NSDictionary * params = @{@"a": placeName};
    
    [adapter GET:URLString parameters:params success:^(GFNetworkingAdapterDataTask *task, id responseObject) {
        
        NSData * data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString * string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (self.view) {
            [self.view showPlaceInfoResult:string];
        }
        
    } failure:^(GFNetworkingAdapterDataTask *task, NSError *error) {
        
        NSLog(@"error:  %@", error);
        
    }];
}

@end
