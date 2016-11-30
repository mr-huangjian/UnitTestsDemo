//
//  User.m
//  UnitTestsDemo
//
//  Created by huangjian on 16/11/29.
//  Copyright © 2016年 bojoy. All rights reserved.
//

#import "User.h"

@implementation User

- (BOOL)containChinese:(NSString *)string {
    
    for(int i = 0; i < string.length; i++) {
        int a = [string characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){
            return YES;
        }
    }
    return NO;
}

@end
