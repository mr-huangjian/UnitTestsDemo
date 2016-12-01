//
//  PlaceInfoViewController.m
//  UnitTestsDemo
//
//  Created by huangjian on 16/12/1.
//  Copyright © 2016年 bojoy. All rights reserved.
//

#import "PlaceInfoViewController.h"
#import "PlaceInfoPresenter.h"

@interface PlaceInfoViewController () <PlaceInfoViewProtocol>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView  *textView;

@property (nonatomic, strong) PlaceInfoPresenter * presenter;

@end

@implementation PlaceInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.presenter = [[PlaceInfoPresenter alloc] initWithView:self];
}

- (IBAction)getPlaceInfoAction:(UIButton *)sender {
    
    [self.presenter loadData:self.textField.text];
}

- (void)showPlaceInfoResult:(NSString *)result {
    
    self.textView.text = result;
}

@end
