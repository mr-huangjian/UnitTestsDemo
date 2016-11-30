//
//  User.h
//  UnitTestsDemo
//
//  Created by huangjian on 16/11/29.
//  Copyright © 2016年 bojoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * password;

- (BOOL)containChinese:(NSString *)string;

@end
