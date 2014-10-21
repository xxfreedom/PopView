//
//  AlertManager.h
//  PopView
//
//  Created by sy on 14-10-21.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class SYAlertAction;
@interface AlertManager : NSObject
+(id)createAlertWithTitle:(NSString *)title AndMessage:(NSString *)message;
@end
@interface SYCAlert : UIView
@property (nonatomic,strong)UIColor *titleColor;
@property (nonatomic,strong)UIColor *messageColor;
-(id)initWithTitle:(NSString *)title AndMessage:(NSString*)message;
-(void)showInView:(UIView *)view;
-(void)showInKeyWindow;
-(void)showInNormalWindow;
-(void)dismiss;
-(void)addAlertAction:(SYAlertAction *)action;
@end
@interface SYAlertAction : NSObject
+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(SYAlertAction *action))handler;
@end