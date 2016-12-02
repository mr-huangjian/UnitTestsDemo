//
//  ViewController.m
//  UnitTestsDemo
//
//  Created by huangjian on 16/11/29.
//  Copyright © 2016年 bojoy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton    *loginButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // info.plist
    // key:                     Bundle OS Type code(CFBundlePackageType)
    // value in framework:      FMWK
    // value in app:            APPL
    
    // NSDictionary * infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // NSLog(@"infoDictionary:  %@", [infoDictionary objectForKey:@"CFBundlePackageType"]);
    
    // NSLog(@"%d", [self appRunningOnDevice]);
    
    NSLog(@"%@", [self readConfigurationFile:@"libConfig.json"]);
    NSLog(@"%@", [self readConfigurationFile:@"libConfig.plist"]);
}

- (NSDictionary *)readConfigurationFile:(NSString *)name {

    NSString * file = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    
    if (file) {
        NSString * ext = [file pathExtension];
        
        if ([ext isEqualToString:@"json"]) {
            
            NSData * data = [NSData dataWithContentsOfFile:file];
            
            NSError * error;
            NSDictionary * object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            
            if (error == nil) {
                return object;
            }
            
        } else if ([ext isEqualToString:@"plist"]) {
            
            NSDictionary * object = [NSDictionary dictionaryWithContentsOfFile:file];
            
            return object;
        }
    }
    
    return nil;
}

- (BOOL)appRunningOnDevice {
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    return YES;
#endif
}

- (IBAction)loginButtonAction:(UIButton *)sender {
    
    if ([self.usernameTextField.text isEqualToString:@"qiye"] && [self.passwordTextField.text isEqualToString:@"123"]) {
        UIViewController * viewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginSuccess"];
        
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
