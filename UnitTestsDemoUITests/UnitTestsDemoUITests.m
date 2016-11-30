//
//  UnitTestsDemoUITests.m
//  UnitTestsDemoUITests
//
//  Created by huangjian on 16/11/29.
//  Copyright © 2016年 bojoy. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface UnitTestsDemoUITests : XCTestCase

@end

@implementation UnitTestsDemoUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testLogin {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *element = [[[[app.otherElements containingType:XCUIElementTypeNavigationBar identifier:@"View"] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    
    XCUIElement *textField = [[element childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:0];
    [textField tap];
    [textField typeText:@"qiye"];
    
    XCUIElement *textField2 = [[element childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:1];
    [textField2 tap];
    [textField2 typeText:@"123"];
    
    [app.buttons[@"Login"] tap];
    
    NSLog(@"identifier:  %@", app.navigationBars.element.identifier);
    
    XCTAssertEqualObjects(app.navigationBars.element.identifier, @"loginSuccess");
    
    /**
     *  如果界面UI元素中出现中文，UITest脚本报错，使用下边方法解决：
     *
     *  You can use the following workaround as this seems to be a bug in xcode:  replace all \U to \u and it should work.
     */
}

@end
