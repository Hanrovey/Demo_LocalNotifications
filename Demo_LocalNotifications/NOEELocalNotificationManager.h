//
//  NOEELocalNotificationManager.h
//  LocalNotification
//
//  Created by Hanrovey on 2017/8/21.
//  Copyright © 2017年 long. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

extern NSString *const kAlertBody_SilentUsers;// 沉默用户提醒内容
extern NSString *const kAlertBody_BuyLottory;// 购彩提醒内容
extern NSString *const kLocalNotification_SlientUserKey;//沉默用户唤醒通知的key

@interface NOEELocalNotificationManager : NSObject

/** app的launchOption */
@property(nonatomic,strong) NSDictionary *launchOption;

/** 程序是否启动完毕标志 */
@property(nonatomic,assign) BOOL launched;


/**
 创建单例对象
 
 @return 单例对象
 */
+ (instancetype)shareManager;


/**
 注册本地通知及用户授权
 */
- (void)registerLocalNotification;


/**
 在购彩大厅(NOEELotteryHallVC.m) -(void)viewdidload{} 里面设置YES,处理本地通知页面跳转
 */
- (void)setAreadyLaunched:(BOOL)launched;


/**
 保存launchOption
 */
- (void)saveLanchOption:(NSDictionary *)launchOption;


/**
 程序活跃的时候，点击通知，执行页面跳转
*/
- (void)dealUserInfoWhenApplicationActiveThenJumpViewController_iOS8:(NSDictionary *)userInfo;


/**
 沉默用户唤醒:创建单个本地通知，一段时间之后的一个本地通知(iOS8)
 
 @param timeInterval 时间间隔(单位s)
 */
- (void)setLocalNotificationToSlientUser_iOS8:(NSTimeInterval)timeInterval;


/**
 沉默用户唤醒:创建单个本地通知，一段时间之后的一个本地通知(iOS10)
 
 @param timeInterval 时间间隔(单位s)
 */
- (void)setLocalNotificationToSlientUser_iOS10:(NSTimeInterval)timeInterval;


/**
 沉默用户唤醒:批量创建30个本地通知(iOS8)
 */
- (void)batchCreate30LocalNotificationToSlientUser_iOS8;


/**
 沉默用户唤醒:批量创建30个本地通知(iOS10)
 */
- (void)batchCreate30LocalNotificationToSlientUser_iOS10;


/**
 沉默用户唤醒:批量创建30个本地通知(iOS8或者iOS10自适配)
 */
- (void)batchCreate30LocalNotificationToSlientUser_iOS8OriOS10;


/**
 购彩提醒:创建每周几某个时间点的本地通知(iOS8)
 
 @param ID 标志
 @param tag 通知标志符
 @param title 通知标题
 @param weekday 周几:周一为1，周二为2...周日
 @param hour 时
 @param minute 分
 @param second 秒
 */
- (void)setLocalNotificationToLottory_iOS8WithID:(NSString *)ID
                                             tag:(NSString *)tag
                                             title:(NSString *)title
                                           weekday:(NSInteger)weekday
                                              hour:(NSInteger)hour
                                            minute:(NSInteger)minute
                                            second:(NSInteger)second;


/**
 购彩提醒:创建每周几某个时间点的本地通知(iOS10)

 @param ID 标志
 @param tag 通知标志符
 @param title 通知标题
 @param weekday 周几:周一为1，周二为2...周日
 @param hour 时
 @param minute 分
 @param second 秒
 */
- (void)setLocalNotificationToLottory_iOS10WithID:(NSString *)ID
                                            tag:(NSString *)tag
                                             title:(NSString *)title
                                           weekday:(NSInteger)weekday
                                              hour:(NSInteger)hour
                                            minute:(NSInteger)minute
                                            second:(NSInteger)second;


/**
 购彩提醒:创建每周几某个时间点的本地通知(iOS8或iOS10自适配)
 
 @param ID 标志
 @param tag 通知标志符
 @param title 通知标题
 @param weekday 周几:周一为1，周二为2...周日
 @param hour 时
 @param minute 分
 @param second 秒
 */
- (void)setLocalNotificationToLottory_iOS8OriOS10WithID:(NSString *)ID
                                                    tag:(NSString *)tag
                                             title:(NSString *)title
                                           weekday:(NSInteger)weekday
                                              hour:(NSInteger)hour
                                            minute:(NSInteger)minute
                                            second:(NSInteger)second;



/**
 根据key来取消单个本地通知

 @param key 通知标志
 */
- (void)cancelLocalNotificationsWithKey:(NSString *)key;


/**
 取消全部本地通知
 */
- (void)cancelAllLocalNotifications;

@end
