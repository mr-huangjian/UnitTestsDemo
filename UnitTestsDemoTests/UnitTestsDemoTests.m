//
//  UnitTestsDemoTests.m
//  UnitTestsDemoTests
//
//  Created by huangjian on 16/11/29.
//  Copyright © 2016年 bojoy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <GFNetworking/GFNetworking.h>

// waitForExpectationsWithTimeout是等待时间，超过了就不再等待往下执行。
#define WAIT do {\
    [self expectationForNotification:@"UnitTest" object:nil handler:nil];\
    [self waitForExpectationsWithTimeout:30 handler:nil];\
} while (0);

#define NOTIFY [[NSNotificationCenter defaultCenter] postNotificationName:@"UnitTest" object:nil];

@interface UnitTestsDemoTests : XCTestCase

@end

@implementation UnitTestsDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    NSLog(@"Enter custom test example ...");
    
    BOOL OK = NO;
    
    XCTAssertTrue(OK == NO, @"OK没有等于NO!，测试不通过！");
}

- (void)testDevice {
    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"Running on simulator.");
#else
    NSLog(@"Running on device.");
#endif
    
#if TARGET_OS_IPHONE
    NSLog(@"Running on device.");
#else
    NSLog(@"Running on simulator.");
#endif
    
#if TARGET_OS_IPHONE
    NSLog(@"Running on device.");
#elif TARGET_OS_SIMULATOR
    NSLog(@"Running on simulator.");
#endif
    
}

- (void)testRequest {

    NSString * URLString = @"http://cache.video.iqiyi.com/jp/avlist/202861101/1/?callback=jsonp9";
    
    GFNetworkingAdapter * adapter = [GFNetworkingAdapter manager];
    adapter.responseSerializer = [GFHTTPResponseSerializer serializer];
    
    [adapter GET:URLString parameters:nil success:^(GFNetworkingAdapterDataTask *task, id responseObject) {
        
        NSLog(@"responseObject:  %@\n", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        XCTAssertNotNil(responseObject, @"返回数据为空");
        
        NOTIFY // 继续执行
        
    } failure:^(GFNetworkingAdapterDataTask *task, NSError *error) {
        
        NSLog(@"error:  %@", error);
        
        XCTAssertNil(error, @"请求出错");
        
        NOTIFY // 继续执行
        
    }];
    
    WAIT // 暂停
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        
        for (int i = 0; i < 10000; i++) {
            NSLog(@"i = %d", i);
        }
        
        NSLog(@"\n");
    }];
    
//    重复执行上面的代码，会收集每次执行的时间，并计算出平均值，每次执行后会跟平均值进行比较，给你参考性的提示。
}

@end
