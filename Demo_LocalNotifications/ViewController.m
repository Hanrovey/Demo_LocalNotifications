//
//  ViewController.m
//  Demo_LocalNotifications
//
//  Created by Hanrovey on 2017/8/25.
//  Copyright © 2017年 Hanrovey. All rights reserved.
//

#import "ViewController.h"
#import "NOEELocalNotificationManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 创建一个10min之后的本地沉默用户唤醒通知（默认七天后的10min)
    [[NOEELocalNotificationManager shareManager] setLocalNotificationToSlientUser_iOS8:10*60];
    
    // 批量创建30个本地沉默用户唤醒通知，默认是每天06:00:00提醒
    [[NOEELocalNotificationManager shareManager] batchCreate30LocalNotificationToSlientUser_iOS8OriOS10];// 重新创建30个沉默用户唤醒本地通知
    
    // 创建一个每个固定星期固定时间点的本地通知 例:每周一 06:00:00
    [[NOEELocalNotificationManager shareManager] setLocalNotificationToLottory_iOS8WithID:@"123" tag:@"tag" title:@"本地定时定点通知" weekday:1 hour:06 minute:00 second:0];
    
    // 取消单个通知
    [[NOEELocalNotificationManager shareManager] cancelLocalNotificationsWithKey:@"key"];
    
    // 取消全部本地通知
    [[NOEELocalNotificationManager shareManager] cancelAllLocalNotifications];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
