//
//  PlaceInfoPresenter.h
//  UnitTestsDemo
//
//  Created by huangjian on 16/12/1.
//  Copyright © 2016年 bojoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PlaceInfoViewProtocol <NSObject>

- (void)showPlaceInfoResult:(NSString *)result;

@end

@protocol PlaceInfoPresenterProtocol

- (void)loadData:(NSString*)placeName;

@end

@interface PlaceInfoPresenter : NSObject <PlaceInfoPresenterProtocol>

@property (nonatomic, strong) id<PlaceInfoViewProtocol> view;

- (instancetype)initWithView:(id<PlaceInfoViewProtocol>) view;

@end
