//
//  AlertManager.m
//  PopView
//
//  Created by sy on 14-10-21.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import "AlertManager.h"



typedef void (^handler)(SYAlertAction *action);
@interface SYAlertAction()

@property(nonatomic,strong)UIButton *confirmbutton;
@property(nonatomic,copy)handler handlerblock;
@end

@implementation SYAlertAction

+ (instancetype)actionWithTitle:(NSString *)title handler:(void (^)(SYAlertAction *action))handler
{
    SYAlertAction * action=[[SYAlertAction alloc]init];;
    if(action)
    {
        action.handlerblock=handler;
        action.confirmbutton=[UIButton buttonWithType:UIButtonTypeCustom];
        [action.confirmbutton addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [action.confirmbutton setTitle:title forState:UIControlStateNormal];
    }
    return action;
}
-(IBAction)click:(id)sender
{
    if(_handlerblock)
    {
        __weak  typeof(self) wself=self;
        _handlerblock(wself);
    }
}


@end

@implementation AlertManager
+(id)createAlertWithTitle:(NSString *)title AndMessage:(NSString *)message
{
    SYCAlert *alert=[[SYCAlert alloc]initWithTitle:title AndMessage:message];
    return alert;
}
@end

@interface SYCAlert()
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *messageLabel;
@property(nonatomic,strong)UIView  *confirmView;
@property(nonatomic,strong)UIView  *backView;
@property(nonatomic,strong)NSMutableArray *clcikHandles;
@end
@implementation SYCAlert
-(instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    return self;
}
-(id)initWithTitle:(NSString *)title AndMessage:(NSString*)message
{
    CGRect rect=[UIScreen mainScreen].bounds;
     self = [super initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
    if(self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        _clcikHandles=[[NSMutableArray alloc]init];
        
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.translatesAutoresizingMaskIntoConstraints=NO;
        _titleLabel.text=title;
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        _titleLabel.textAlignment=NSTextAlignmentCenter;
        _titleLabel.numberOfLines=1;
        
        _messageLabel=[[UILabel alloc]init];
        _messageLabel.translatesAutoresizingMaskIntoConstraints=NO;
        _messageLabel.text=message;
        _messageLabel.textAlignment=NSTextAlignmentCenter;
        [_messageLabel setFont:[UIFont systemFontOfSize:15]];
        _messageLabel.numberOfLines=0;
        
        _confirmView=[[UIView alloc]init];
        _confirmView.translatesAutoresizingMaskIntoConstraints=NO;
        
        _backView=[[UIView alloc]init];
        _backView.translatesAutoresizingMaskIntoConstraints=NO;
        [_backView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [self addSubview:_backView];
        
        
        CGFloat height=[self countSubviewsFrameWith:message withWidth:290 withFontSize:15].height;
        NSDictionary *dic_back=NSDictionaryOfVariableBindings(_backView);
        NSString *VFL_Back_V=[NSString stringWithFormat:@"V:[_backView(%f)]",height+20+60];
        NSString *VFL_Back_H=@"H:[_backView(290)]";
        NSMutableArray *constraint_Back=[[NSMutableArray alloc]init];
        [constraint_Back addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:VFL_Back_V options:NSLayoutFormatAlignAllCenterX metrics:nil views:dic_back]];
        [constraint_Back addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:VFL_Back_H options:NSLayoutFormatAlignAllCenterY metrics:nil views:dic_back]];
        [constraint_Back addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_backView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [constraint_Back addObject:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [self addConstraints:constraint_Back];
        
        [_backView addSubview:_titleLabel];
        [_backView addSubview:_messageLabel];
        [_backView addSubview:_confirmView];
        NSDictionary *dic_backSub=NSDictionaryOfVariableBindings(_titleLabel,_confirmView,_messageLabel);
        NSString *VFL_BackSub_H=@"H:|-[_titleLabel]-|";
        NSString *VFL_BackSubM_H=@"H:[_messageLabel(==_titleLabel)]";
        NSString *VFL_BackSubC_H=@"H:[_confirmView(==_titleLabel)]";
        NSString *VFL_BackSub_V=@"V:|-0-[_titleLabel(30)]-10-[_messageLabel]-10-[_confirmView(30)]-0-|";
        NSMutableArray *constraint_BackSub=[[NSMutableArray alloc]init];
        [constraint_BackSub addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:VFL_BackSub_H options:NSLayoutFormatAlignAllBaseline metrics:nil views:dic_backSub]];
        [constraint_BackSub addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:VFL_BackSubC_H options:NSLayoutFormatAlignAllBaseline metrics:nil views:dic_backSub]];
        [constraint_BackSub addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:VFL_BackSubM_H options:NSLayoutFormatAlignAllBaseline metrics:nil views:dic_backSub]];
        
        [constraint_BackSub addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:VFL_BackSub_V options:NSLayoutFormatAlignAllCenterX metrics:nil views:dic_backSub]];
        [self addConstraints:constraint_BackSub];
    }
    return self;
}
-(void)showInView:(UIView *)view
{
    [view addSubview:self];
    [self setAlpha:0.0];
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:1.0];
    } completion:^(BOOL finished) {
        
    }];
}
-(void)showInKeyWindow
{
    UIWindow *window=[[[UIApplication sharedApplication]windows] lastObject];
    [self showInView:window];
}
-(void)showInNormalWindow
{
    __block UIWindow  * keywindow;
    [[[UIApplication sharedApplication]windows]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if(((UIWindow *)obj).windowLevel==UIWindowLevelNormal)
        {
            keywindow=obj;
        }
    }];
    [self showInView:keywindow];
}
-(void)dismiss
{
    [UIView animateWithDuration:0.3 animations:^{
        [self setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(CGSize)countSubviewsFrameWith:(NSString*)title withWidth:(int)width withFontSize:(int)fontSize
{
    CGSize labelSize;
    if ([[[UIDevice currentDevice]systemVersion] floatValue] >= 7.0)
    {
        NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName,nil];
        labelSize=[title boundingRectWithSize:CGSizeMake(width,FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    }
    else
        labelSize = [title sizeWithFont:[UIFont systemFontOfSize:fontSize]
                      constrainedToSize:CGSizeMake(width,FLT_MAX)
                          lineBreakMode:NSLineBreakByWordWrapping];
    return labelSize;
}
-(void)addAlertAction:(SYAlertAction *)action
{
    [_clcikHandles addObject:action];
    [self resetAutolayout];
}
-(void)resetAutolayout
{
    if(_confirmView)
    {
        [[_confirmView subviews]enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj removeFromSuperview];
        }];
        
        [_clcikHandles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [_confirmView addSubview:((SYAlertAction *)obj).confirmbutton];
        }];
        
        NSMutableArray *constraints=[[NSMutableArray alloc]init];
        for (int i=0; i<_clcikHandles.count; i++) {
            UIButton *current=((SYAlertAction *)_clcikHandles[i]).confirmbutton;
            if(i==0)
            {
                if(i==(_clcikHandles.count-1))
                {
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:_confirmView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:current attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                    
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:current attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_confirmView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                }else
                {
                    UIButton *nextbutton=((SYAlertAction *)_clcikHandles[i+1]).confirmbutton;
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:_confirmView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:current attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                    
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:current attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:nextbutton attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                }
            }else if(i==(_clcikHandles.count-1))
            {
                UIButton *prebutton=((SYAlertAction *)_clcikHandles[i-1]).confirmbutton;
                [constraints addObject:[NSLayoutConstraint constraintWithItem:prebutton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:current attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                
                [constraints addObject:[NSLayoutConstraint constraintWithItem:prebutton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:current attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
                
                [constraints addObject:[NSLayoutConstraint constraintWithItem:current attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_confirmView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
            }else
            {
                UIButton *prebutton=((SYAlertAction *)_clcikHandles[i-1]).confirmbutton;
                UIButton *nextbutton=((SYAlertAction *)_clcikHandles[i+1]).confirmbutton;
                [constraints addObject:[NSLayoutConstraint constraintWithItem:prebutton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:current attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                
                [constraints addObject:[NSLayoutConstraint constraintWithItem:prebutton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:current attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
                
                [constraints addObject:[NSLayoutConstraint constraintWithItem:current attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:nextbutton attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
            }
            
            [constraints addObject:[NSLayoutConstraint constraintWithItem:_confirmView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:current attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
            [constraints addObject:[NSLayoutConstraint constraintWithItem:_confirmView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:current attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        }
        [_confirmView addConstraints:constraints];
    }
}
@end
