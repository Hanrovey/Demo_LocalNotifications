//
//  NOEELocalNotificationManager.m
//  LocalNotification
//
//  Created by Hanrovey on 2017/8/21.
//  Copyright © 2017年 long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NOEELocalNotificationManager.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

#define kAlertCount 30
NSString *const kAlertBody_SilentUsers = @"其实你有1000万存款，只不过你忘记了取款密码，每输入一次密码需2元，一旦密码正确钱就是你的了。不着急，不放弃，心若在，梦就在。";
NSString *const kAlertBody_BuyLottory = @"梦想还是要有的，万一中了呢～";
NSString *const kLocalNotification_SlientUserKey = @"kLocalNotification_SlientUserKey";

@interface NOEELocalNotificationManager()<UNUserNotificationCenterDelegate>
@end

@implementation NOEELocalNotificationManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.launchOption = [NSDictionary dictionary];
        self.launched = NO;
    }
    return self;
}

+ (instancetype)shareManager
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

#pragma mark - 注册本地通知及用户授权(iOS8 和  iOS10)
- (void)registerLocalNotification
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        [self registeriOS10LocalNotification];
    } else
    {
        [self registeriOS8LocalNotification];
    }
}

#pragma mark - 在购彩大厅viewdidload里面设置YES
- (void)setAreadyLaunched:(BOOL)launched
{
    _launched = launched;
    
    if (!self.launchOption)  return;
    
    if (!_launched) return;
    
    NSDictionary *userInfo = [[self.launchOption objectForKey:UIApplicationLaunchOptionsLocalNotificationKey] userInfo];
    
    if (userInfo == nil) return;
    
    NSString *url = @"";
    for (NSString *key in userInfo.allKeys)
    {
        if ([key isEqualToString:@"url"])
        {
            url = userInfo[key];
        }
    }
    
    if (url && url.length > 0)
    {
        // 页面跳转
        [self performSelector:@selector(jumpViewControllerWithUrl:) withObject:url afterDelay:0.5];
    }
}

#pragma mark - 程序活跃的时候，点击通知，执行页面跳转
- (void)dealUserInfoWhenApplicationActiveThenJumpViewController_iOS8:(NSDictionary *)userInfo
{
    if (userInfo == nil) return;
    
    NSString *url = @"";
    for (NSString *key in userInfo.allKeys)
    {
        if ([key isEqualToString:@"url"])
        {
            url = userInfo[key];
        }
    }
    
    if (url && url.length > 0)
    {
        // 页面跳转
        [self performSelector:@selector(jumpViewControllerWithUrl:) withObject:url afterDelay:0.5];
    }
}

#pragma mark - 程序死掉的时候，点击通知，根据url跳转页面
- (void)jumpViewControllerWithUrl:(NSString *)url
{
    if (url.length)
    {
        // 跳转页面代码在这边执行
        
    }
}


#pragma mark - 保存launchOption
- (void)saveLanchOption:(NSDictionary *)launchOption
{
    self.launchOption = launchOption;
}

#pragma mark - 注册本地通知及用户授权
- (void)registeriOS10LocalNotification
{
    //iOS10特有
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    // 必须写代理，不然无法监听通知的接收与点击,只能是application对象
    //    center.delegate = self;
    
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if(granted)
        {
            //用户点击允许
            NSLog(@"注册成功");
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                NSLog(@"%@", settings);
            }];
        }else
        {
            //用户点击不允许
            NSLog(@"注册失败");
        }
    }];
}

- (void)registeriOS8LocalNotification
{
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        // 创建UIUserNotificationSettings，并设置消息的显示类类型
        UIUserNotificationSettings *uns = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound) categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:uns];
    }
}

#pragma mark - 批量创建30个本地通知(iOS8和iOS10自适配)
- (void)batchCreate30LocalNotificationToSlientUser_iOS8OriOS10
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        [self batchCreate30LocalNotificationToSlientUser_iOS10];
    } else
    {
        [self batchCreate30LocalNotificationToSlientUser_iOS8];
    }
    
}

#pragma mark - 批量创建30个本地通知(iOS8)
- (void)batchCreate30LocalNotificationToSlientUser_iOS8
{
    for (int i = 0; i < kAlertCount; i++)
    {
        // 批量创建30个本地通知，7天后，8天后.....37天后
        NSTimeInterval timeInterval = (7 + i) * 24 * 60 * 60;
        [self setLocalNotificationToSlientUser_iOS8:timeInterval];
    }
}

#pragma mark - 批量创建30个本地通知(iOS10)
- (void)batchCreate30LocalNotificationToSlientUser_iOS10
{
    for (int i = 0; i < kAlertCount; i++)
    {
        // 批量创建30个本地通知，7天后，8天后.....37天后
        NSTimeInterval timeInterval = (7 + i) * 24 * 60 * 60;
        [self setLocalNotificationToSlientUser_iOS10:timeInterval];
    }
}

#pragma mark - 创建单个本地通知，一段时间之后的一个本地通知(iOS8)
- (void)setLocalNotificationToSlientUser_iOS8:(NSTimeInterval)timeInterval
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if (notification)
    {
        // app启动时间 + 7天
        NSDate *dateP7 = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        // 7天后的时间
        NSString *dateP7String = [format stringFromDate:dateP7];
        
        // 7天后的那天六点整
        NSString *date6String = [NSString stringWithFormat:@"%@ 06:00:00",[dateP7String substringToIndex:10]];
        // 7天后六点钟日期
        NSDate *transDate = [format dateFromString:date6String];
        
        // 时间差
        NSTimeInterval temInterval = [transDate timeIntervalSinceNow];
        
        // 启动时间
        NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:temInterval];
        notification.fireDate = fireDate;
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = kAlertBody_SilentUsers;
        
        NSString *key = [NSString stringWithFormat:@"%f",timeInterval];
        notification.userInfo = @{kLocalNotification_SlientUserKey: key};
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

#pragma mark - 创建单个本地通知，一段时间之后的一个本地通知(iOS10)
- (void)setLocalNotificationToSlientUser_iOS10:(NSTimeInterval)timeInterval
{
    // 推送内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.body = kAlertBody_SilentUsers;
    NSString *key = [NSString stringWithFormat:@"%f",timeInterval];
    content.userInfo = @{kLocalNotification_SlientUserKey: key};
    
    
    // app启动时间 + 7天
    NSDate *dateP7 = [NSDate dateWithTimeIntervalSinceNow:timeInterval];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    // 7天后的时间
    NSString *dateP7String = [format stringFromDate:dateP7];
    
    // 7天后的那天六点整
    NSString *date6String = [NSString stringWithFormat:@"%@ 06:00:00",[dateP7String substringToIndex:10]];
    // 7天后六点钟日期
    NSDate *transDate = [format dateFromString:date6String];
    
    // 时间差
    NSTimeInterval temInterval = [transDate timeIntervalSinceNow];
    
    if (temInterval < 0) return;
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:temInterval repeats:NO];
    
    // 创建通知
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Test" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"iOS 10 发送推送， error：%@", error);
    }];
}

#pragma mark - 创建每周几某个时间点的本地通知(iOS8或iOS10自适配)
- (void)setLocalNotificationToLottory_iOS8OriOS10WithID:(NSString *)ID
                                                    tag:(NSString *)tag
                                                  title:(NSString *)title
                                                weekday:(NSInteger)weekday
                                                   hour:(NSInteger)hour
                                                 minute:(NSInteger)minute
                                                 second:(NSInteger)second
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        [self setLocalNotificationToLottory_iOS10WithID:ID
                                                    tag:tag
                                                  title:title
                                                weekday:weekday
                                                   hour:hour
                                                 minute:minute
                                                 second:second];
    } else
    {
        [self setLocalNotificationToLottory_iOS8WithID:ID
                                                   tag:tag
                                                 title:title
                                               weekday:weekday
                                                  hour:hour
                                                minute:minute
                                                second:second];
    }
}


#pragma mark - 创建每周几某个时间点的本地通知(iOS8)
- (void)setLocalNotificationToLottory_iOS8WithID:(NSString *)ID tag:(NSString *)tag title:(NSString *)title weekday:(NSInteger)weekday hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.timeZone = [NSTimeZone defaultTimeZone]; // 使用本地时区
    
    // 转换成本地时区的时间，要不然差8小时
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:localeDate];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    
    NSInteger unitFlags = NSCalendarUnitEra |
    NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond |
    NSCalendarUnitWeekOfYear |
    NSCalendarUnitWeekday |
    NSCalendarUnitWeekdayOrdinal |
    NSCalendarUnitQuarter;
    
    comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date]];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    
    int temp = 0;
    int days = 0;
    
    // weekday默认周日为1，因此周一的话为2
    temp = weekday + 1 - components.weekday;
    days = (temp >= 0 ? temp : temp + 7);
    NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * days];
    
    // 设置提醒时间
    notification.fireDate = newFireDate;
    
    // 设置重复间隔
    notification.repeatInterval = kCFCalendarUnitWeek;
    
    // 设置提醒的标题内容
    //    notification.alertTitle = title;
    
    // 设置提醒的文字内容
    notification.alertBody = title;
    
    // 通知提示音 使用默认的
    notification.soundName= UILocalNotificationDefaultSoundName;
    
    // 彩种的本地URL
    NSString *url = [NSString stringWithFormat:@"http://mobile.9188.com/app?pagetype=Lottery&pageid=%@&pagetab=tz&pageextend=",ID];
    notification.userInfo = @{
                              @"ID":ID,
                              tag:tag,
                              @"url":url
                              };
    
    // 将通知添加到系统中
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

#pragma mark - 创建每周几某个时间点的本地通知(iOS10)
- (void)setLocalNotificationToLottory_iOS10WithID:(NSString *)ID tag:(NSString *)tag title:(NSString *)title weekday:(NSInteger)weekday hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second
{
    // 推送内容
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = title;
    content.body = kAlertBody_BuyLottory;
    // 彩种的本地URL
    NSString *url = [NSString stringWithFormat:@"http://mobile.9188.com/app?pagetype=Lottery&pageid=%@&pagetab=tz&pageextend=",ID];
    content.userInfo = @{
                         @"ID":ID,
                         tag:tag,
                         @"url":url
                         };
    
    
    // 转换成本地时区的时间，要不然差8小时
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSDateComponents * components = [[NSCalendar currentCalendar] components:NSCalendarUnitWeekday|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:localeDate];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init] ;
    
    NSInteger unitFlags = NSCalendarUnitEra |
    NSCalendarUnitYear |
    NSCalendarUnitMonth |
    NSCalendarUnitDay |
    NSCalendarUnitHour |
    NSCalendarUnitMinute |
    NSCalendarUnitSecond |
    NSCalendarUnitWeekOfYear |
    NSCalendarUnitWeekday |
    NSCalendarUnitWeekdayOrdinal |
    NSCalendarUnitQuarter;
    
    comps = [[NSCalendar currentCalendar] components:unitFlags fromDate:[NSDate date]];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    
    int temp = 0;
    int days = 0;
    
    // weekday默认周日为1，因此周一的话为2
    temp = weekday + 1 - components.weekday;
    days = (temp >= 0 ? temp : temp + 7);
    NSDate *newFireDate = [[[NSCalendar currentCalendar] dateFromComponents:comps] dateByAddingTimeInterval:3600 * 24 * days];
    
    // 时间差
    NSTimeInterval temInterval = [newFireDate timeIntervalSinceNow];
    
    if (temInterval < 0) return;
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:temInterval repeats:NO];
    
    // 创建通知
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"Test_ios10" content:content trigger:trigger];
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        NSLog(@"iOS 10 发送推送， error：%@", error);
    }];
}

#pragma mark - 取消单个本地通知
- (void)cancelLocalNotificationsWithKey:(NSString *)key
{
    NSArray *notifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
    NSUInteger count = [notifications count];
    if (count > 0)
    {
        // 遍历找到对应nfkey和notificationtag的通知
        for (int i = 0; i < count; i++)
            　　 {
                UILocalNotification *tempNotification = [notifications objectAtIndex:i];
                NSDictionary *userInfo = tempNotification.userInfo;
                if ([userInfo.allKeys containsObject:key])
                {
                    // 删除本地通知
                    [[UIApplication sharedApplication] cancelLocalNotification:tempNotification];
                    break;
                }
            }
    }
}

#pragma mark - 取消全部本地 通知
- (void)cancelAllLocalNotifications
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
@end
