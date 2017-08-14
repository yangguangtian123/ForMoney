//
//  LBBTimeTool.m
//  LBBApp
//
//  Created by mac on 14-10-12.
//  Copyright (c) 2014年 王渊浩. All rights reserved.
//

#import "LBBTimeTool.h"

@implementation LBBTimeTool
+ (NSString *)intervalSinceNow: (NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    
    
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        if (cha/60<1) {
            timeString = @"1";
        }
        else
        {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            timeString = [timeString substringToIndex:timeString.length-7];
        }
        
        timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
    }
    else if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    else if (cha/86400>1&&cha/864000<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    else
    {
        //        timeString = [NSString stringWithFormat:@"%d-%"]
        NSArray *array = [theDate componentsSeparatedByString:@" "];
        //        return [array objectAtIndex:0];
        timeString = [array objectAtIndex:0];
    }
    return timeString;
}
+(NSString *)timeStrSinceNow: (NSTimeInterval)timeInterval{
 
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:timeInterval];//计算出这么多时间之后的一个时间,若计算之前的时间,传负值
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *pastTime = [formatter stringFromDate:dat];
    return pastTime;
  
}




+(NSDate *)dateFromString:(NSString *)timeStr{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* date = [df dateFromString:timeStr];
    return date;
}

+(NSString *)getCurrentTime{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentTime = [formatter stringFromDate:date];
    return currentTime;

}

+(NSString *)getDetailCurrentTime{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss:SSS"];
    NSString *currentTime = [formatter stringFromDate:date];
    return currentTime;
    
}



+(NSString *)timeTotime:(NSString *)time{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* inputDate = [inputFormatter dateFromString:time];
    NSString *inpt = [inputFormatter stringFromDate:inputDate];
    
    return inpt;
    
}

+ (NSTimeInterval )getGapTime1:(NSString *)time1 toTime2:(NSString *)time2{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeD1 = [inputFormatter dateFromString:time1];
    NSDate *timeD2 = [inputFormatter dateFromString:time2];
    
    return fabs([timeD1 timeIntervalSinceDate:timeD2]);
}


//+ (BOOL)getGapTime1:(NSString *)time1 toTime2:(NSString *)time2{
 

//比较两天的时间那个大,
+ (BOOL)isTime1:(NSString *)time1 isBiggerThanTime2:(NSString *)time2{

    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *timeD1 = [inputFormatter dateFromString:time1];
    NSDate *timeD2 = [inputFormatter dateFromString:time2];
    
    if([timeD1 timeIntervalSinceDate:timeD2]>=0){
        return YES;
    }else{
        return NO;
    }
}


//比较两个时间那个大,只有时分秒
+ (BOOL)isHourTime1:(NSString *)time1 isBiggerThanHourTime2:(NSString *)time2{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"HH:mm"];
    NSDate *timeD1 = [inputFormatter dateFromString:time1];
    NSDate *timeD2 = [inputFormatter dateFromString:time2];
    
    if([timeD1 timeIntervalSinceDate:timeD2]>=0){
        return YES;
    }else{
        return NO;
    }
}







+ (NSTimeInterval )getTimeGapToNow:(NSString *)time{
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeD = [inputFormatter dateFromString:time];
    return fabs(timeD.timeIntervalSinceNow);
    
}

+(NSString *)timeToNewTime:(NSString *)Numbertime
{
    if (Numbertime.length == 0) {
        Numbertime= @"";
        return Numbertime;
    }
    NSLog(@"kkkkkkkk------%@",Numbertime);
    // 计算剩余时间  2015-01-07 16:33:13
    //NSString * newTime = [Numbertime substringToIndex:Numbertime.length-2];
    // 将2015-01-07 16:33:13 按照指定的格式转化为NSDate
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * date = [formatter dateFromString:Numbertime];
    // 日历
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDate * today = [NSDate date];
    NSLog(@"%@",date);
    if (date == nil) {
        Numbertime= @"";
        return Numbertime;
    }
    // 时间比较
    // 时间片段 ：年 月  日  时 分 秒
    int unit = NSCalendarUnitYear | NSCalendarUnitMonth  | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents * com = [calendar components:unit fromDate:date toDate:today options:0];
    if(-(long)com.year >= 1){
        Numbertime = @"";
    }else{
        Numbertime = [NSString stringWithFormat:@"距结束还有: %ld天%ld时%ld分", -(long)com.day,-(long)com.hour,-(long)com.minute];
    }
    
    
    if (com.year>=0&&com.day>=0&&com.hour>=0&&com.minute>=0) {
        Numbertime=@"活动已结束,请期待更新!";

        return Numbertime;
    }
    return Numbertime;
}





+(NSString *)getTimeStr{
    NSString *time = [LBBTimeTool getCurrentTime];
    time = [time stringByReplacingOccurrencesOfString:@" " withString:@""];
    time = [time stringByReplacingOccurrencesOfString:@"-" withString:@""];
    time = [time stringByReplacingOccurrencesOfString:@":" withString:@""];
    return time;
    
    
}
+ (NSString *)getDateStrFromDate:(NSDate *)date
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

//将到1970的时间戳转变成时间字符串
+ (NSString *)getTimeStringBy1970Num:(NSTimeInterval )inter{
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:inter]];
}


//获取周几
+ (NSInteger)weekdayStringFromDate:(NSDate*)inputDate {
    
  //  NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    
    switch (theComponents.weekday) {
        case 1:
        {
            return 6;
            
        }
            break;
        case 2:
        {//周一
            return 0;
            
        }
            break;
        case 3:
        {
            return 1;
            
        }
            break;
        case 4:
        {
            return 2;
            
        }
            break;
        case 5:
        {
            return 3;
            
        }
            break;
        case 6:
        {
            return 4;
            
        }
            break;
        case 7:
        {
            return 5;
            
        }
            break;
            
        default:
            break;
    }
    
    return 1;
}




@end





















