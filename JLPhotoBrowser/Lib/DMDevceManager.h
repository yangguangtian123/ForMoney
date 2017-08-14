//
//  DMDevceManager.h
//  dmApp
//
//  Created by long on 8/28/14.
//  Copyright (c) 2014 刘 书龙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/utsname.h>
#import <UIKit/UIKit.h>



@interface DMDevceManager : NSObject

//判断系统是否是iOS7，iOS8
+ (BOOL)isiOS7;

+(BOOL)isiOS8;


// 判断手机型号：iphone 5.6.7
+ (NSString *)iphoneType ;

//判断设备模型
+ (NSString *)deviceModel;
//获取屏幕高度
+ (CGFloat)screenHeight;
//获取屏幕宽度
+ (CGFloat)screenWidth;
//返回设备是否横屏
+ (BOOL)isLandscape;
+ (void)changeScrollViewEdgeInset:(UIScrollView *)scrollView;

@end
