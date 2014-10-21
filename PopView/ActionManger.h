//
//  ActionManger.h
//  PopView
//
//  Created by sy on 14-10-17.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ActionManger : NSObject
+(UIAlertAction*)createYESAcitionWithhandler:(void (^)(UIAlertAction *action))handler;
+(UIAlertAction*)createNOAcitionWithhandler:(void (^)(UIAlertAction *action))handler;
@end
