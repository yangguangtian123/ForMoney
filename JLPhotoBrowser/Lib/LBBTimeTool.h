//
//  LBBTimeTool.h
//  LBBApp
//
//  Created by mac on 14-10-12.
//  Copyright (c) 2014年 王渊浩. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBBTimeTool : NSObject
//计算多久以前的时间,如1天前,几月几号等
+ (NSString *)intervalSinceNow: (NSString *) theDate;
//获取当前时间
+(NSString *)getCurrentTime;

//计算距离现在多少秒的时间,返回的是时间的完整字符串,如2014-01-04 06:06:06,如果传入的是负数,则是以前的时间
+(NSString *)timeStrSinceNow: (NSTimeInterval)timeInterval;
//转换时间显示方式,把不带0的显示成带0的
+(NSString *)timeTotime:(NSString *)time;

//获取当前时间,包含毫秒
+(NSString *)getDetailCurrentTime;

//获取时间间隔
+ (NSTimeInterval )getTimeGapToNow:(NSString *)time;

+ (NSTimeInterval )getGapTime1:(NSString *)time1 toTime2:(NSString *)time2;


+(NSString *)timeToNewTime:(NSString *)Numbertime;//计算时间差距的时间


//比较两天的时间哪个大,
+ (BOOL)isTime1:(NSString *)time1 isBiggerThanTime2:(NSString *)time2;
//比较两个时间(只有 时 分)比较
+ (BOOL)isHourTime1:(NSString *)time1 isBiggerThanHourTime2:(NSString *)time2;


//一个时间戳
+(NSString *)getTimeStr;

+(NSDate *)dateFromString:(NSString *)timeStr;

//给日期转字符串
+ (NSString *)getDateStrFromDate:(NSDate *)date;
//将到1970的时间戳转变成时间字符串
+ (NSString *)getTimeStringBy1970Num:(NSTimeInterval )inter;
 
//获取周几 0-6  分别代表 周一 到 周日
+ (NSInteger)weekdayStringFromDate:(NSDate*)inputDate;



@end









