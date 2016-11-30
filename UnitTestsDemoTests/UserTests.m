//
//  UserTests.m
//  UnitTestsDemo
//
//  Created by huangjian on 16/11/29.
//  Copyright © 2016年 bojoy. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "User.h"
#import "OCMock.h"

@interface UserTests : XCTestCase
{
@private
    User * user;
}
@end

@implementation UserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    user = [[User alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testContainChinese {
    
    XCTAssertTrue([user containChinese:@"123"], @"");
    XCTAssertTrue([user containChinese:@"abc"], @"");
    XCTAssertTrue([user containChinese:@"七夜"], @"");
    
}

- (void)testOCMock {
    
    User * userReal = [[User alloc] init];
    
    /**
     *  通过User类生成一个mock对象
     *  userMock: OCMockObject(User)
     */
    id userMock = OCMClassMock([User class]);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
