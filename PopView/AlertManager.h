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
+(id)createPAlertWithTitle:(NSString *)title;
+(id)createTAlertWithTitle:(NSString *)title;
+(void)showTalertWithTitle:(NSString *)title CloseTime:(CGFloat)closeTime;
@end
@interface SYAlert : UIView
-(void)showInView:(UIView *)view;
-(void)showInKeyWindow;
-(void)showInNormalWindow;
-(void)dismiss;
@end
@interface SYCAlert : SYAlert
@property (nonatomic,strong)UIColor *titleColor;
@property (nonatomic,strong)UIColor *messageColor;
-(id)initWithTitle:(NSString *)title AndMessage:(NSString*)message;
-(void)addAlertAction:(SYAlertAction *)action;
@end
@interface SYPAlert : SYAlert
-(id)initWithTitle:(NSString *)title;
@end
@interface SYTAlert : SYAlert
-(id)initWithTitle:(NSString *)title;
@end
@interface SYAlertAction : NSObject
+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(SYAlertAction *action))handler;
@end