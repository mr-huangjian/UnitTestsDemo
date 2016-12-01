//
//  PlaceInfoTestSpec.m
//  UnitTestsDemo
//
//  Created by huangjian on 16/12/1.
//  Copyright 2016年 bojoy. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "PlaceInfoPresenter.h"
#import "PlaceInfoViewController.h"

// https://onevcat.com/2014/02/ios-test-with-kiwi/
// http://www.jianshu.com/p/7e3f197504c1#
// http://www.jianshu.com/p/9cdeb641c00d

SPEC_BEGIN(PlaceInfoTestSpec)

describe(@"PlaceInfoTest", ^{
    it(@"place info presenter test", ^{
       
        id viewMock = [KWMock mockForProtocol:@protocol(PlaceInfoViewProtocol)];
        [[viewMock should] conformToProtocol:@protocol(PlaceInfoViewProtocol)];
        [viewMock stub:@selector(showPlaceInfoResult:)];
        
        PlaceInfoPresenter * presenter = [[PlaceInfoPresenter alloc] initWithView:viewMock];
        
        [presenter loadData:@"北京"];
        
        [[viewMock shouldEventuallyBeforeTimingOutAfter(3)] receive:@selector(showPlaceInfoResult:) withCount:1];
        
    });
});

SPEC_END
