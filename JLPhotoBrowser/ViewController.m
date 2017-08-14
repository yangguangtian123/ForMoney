//
//  ViewController.m
//  JLPhotoBrowser
//
//  Created by liao on 15/12/24.
//  Copyright © 2015年 BangGu. All rights reserved.
//

//屏幕宽
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "ViewController.h"
#import "JLImageListView.h"
#import "LBBPhotoListVC.h"
#import "LocalAuthentication/LAContext.h"





@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 150, ScreenWidth-40, 100)];
    label.textColor = [UIColor greenColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 3;
    label.text = @"请点击四次\n 然后指纹识别 \n打开";
    [self.view addSubview:label];
    label.userInteractionEnabled = YES;

    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(verifyFingerprint)];
    tap.numberOfTapsRequired = 4 ;

    
    [label addGestureRecognizer:tap];
    
 }


- (void)verifyFingerprint{
    
    //测试
    [self getSuccess];
    return;
    

    
    
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *myLocalizedReasonString = @"We need to verify your fingerprint to confirm your identity";
    
    __block NSString *returnCode;
    
    __weak typeof(self) weakSelf = self;
    
    // 判断设备是否支持指纹识别
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        
        // 指纹识别只判断当前用户是否机主
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:myLocalizedReasonString
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    // User authenticated successfully, take appropriate action
                                    NSLog(@"指纹认证成功");
                                    
                                    returnCode = @"1";
                                    [weakSelf getSuccess];
                                    
                                    
                                } else {
                                    // User did not authenticate successfully, look at error and take appropriate action
                                    NSLog(@"指纹认证失败，%@",error.description);
                                    // 错误码 error.code
                                    // -1: 连续三次指纹识别错误
                                    // -2: 在TouchID对话框中点击了取消按钮
                                    // -3: 在TouchID对话框中点击了输入密码按钮
                                    // -4: TouchID对话框被系统取消，例如按下Home或者电源键
                                    // -8: 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                                    
                                    returnCode = [@(error.code) stringValue];
                                }
                            }];
        
    } else {
        // Could not evaluate policy; look at authError and present an appropriate message to user
        NSLog(@"TouchID设备不可用");
        // TouchID没有设置指纹
        // 关闭密码（系统如果没有设置密码TouchID无法启用）
    }
    NSLog(@"--------- %@",returnCode);
    
    
    
    

}





- (void)getSuccess{
    NSLog(@"hahahhawoaini");
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        LBBPhotoListVC *VC = [[LBBPhotoListVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    });
    
    
  
    
    
    
}




-(void)setupImageViews{
    
    
    
}

@end
