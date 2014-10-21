//
//  ActionManger.m
//  PopView
//
//  Created by sy on 14-10-17.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import "ActionManger.h"

@implementation ActionManger
+(UIAlertAction*)createYESAcitionWithhandler:(void (^)(UIAlertAction *action))handler
{
    UIAlertAction *action_yes=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"我处理");
        handler(action);
    }];

    return action_yes;
}
+(UIAlertAction*)createNOAcitionWithhandler:(void (^)(UIAlertAction *action))handler
{
    UIAlertAction *action_NO=[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"我处理");
        handler(action);
    }];
    return action_NO;
}
@end
