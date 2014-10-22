//
//  AlertManager.m
//  PopView
//
//  Created by sy on 14-10-21.
//  Copyright (c) 2014年 SY. All rights reserved.
//

#import "AlertManager.h"

static NSString *Notification_Dismiss =@"dimiss_SYAlert";
#define LightBlue [UIColor colorWithRed:0.25 green:0.64 blue:1.00 alpha:1.00]
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
        [action.confirmbutton addTarget:action action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [action.confirmbutton setTitleColor:LightBlue forState:UIControlStateNormal];
        [action.confirmbutton setTitle:title forState:UIControlStateNormal];
        [action.confirmbutton.layer setBorderWidth:0.5];
        [action.confirmbutton.layer setBorderColor:LightBlue.CGColor];
    }
    return action;
}
-(IBAction)clickButton:(id)sender
{
    if(_handlerblock)
    {
        __weak  typeof(self) wself=self;
        _handlerblock(wself);
        [[NSNotificationCenter defaultCenter]postNotificationName:Notification_Dismiss object:nil];
    }
}


@end

@implementation AlertManager
+(id)createAlertWithTitle:(NSString *)title AndMessage:(NSString *)message
{
    SYCAlert *alert=[[SYCAlert alloc]initWithTitle:title AndMessage:message];
    return alert;
}
+(id)createPAlertWithTitle:(NSString *)title
{
    SYPAlert *palert=[[SYPAlert alloc]initWithTitle:title];
    return palert;
}
+(id)createTAlertWithTitle:(NSString *)title
{
    SYTAlert *talert=[[SYTAlert alloc]initWithTitle:title];
    return talert;
}
+(void)showTalertWithTitle:(NSString *)title CloseTime:(CGFloat)closeTime
{
    SYTAlert *alert=[[self class] createTAlertWithTitle:title];
    [alert showInKeyWindow];
    [alert performSelector:@selector(dismiss) withObject:nil afterDelay:closeTime];
}
@end

@implementation SYAlert
-(id)init
{
    self=[super init];
    if(self)
    {
        
    }
    return self;
}
-(void)showInView:(UIView *)view
{
    [view addSubview:self];
    [self setAlpha:0.0];
    [UIView animateWithDuration:0.2 animations:^{
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
    [UIView animateWithDuration:0.2 animations:^{
        [self setAlpha:0.0];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
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
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismiss) name:Notification_Dismiss object:nil];
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
        [_confirmView setBackgroundColor:[UIColor whiteColor]];
        
        _backView=[[UIView alloc]init];
        _backView.translatesAutoresizingMaskIntoConstraints=NO;
        [_backView setBackgroundColor:[UIColor whiteColor]];
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
        NSString *VFL_BackSub_H=@"H:|-0-[_titleLabel]-0-|";
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
    [super showInView:view];
//    _backView.layer.transform = CATransform3DMakeScale(0.2, 0.2, 1);
//    [UIView animateWithDuration:0.2 animations:^{
//        _backView.layer.transform = CATransform3DMakeScale(1.1, 1.1, 1);
//    } completion:^(BOOL finished) {
//        _backView.layer.transform = CATransform3DIdentity;
//    }];
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
            UIButton *button=((SYAlertAction *)obj).confirmbutton;
            button.translatesAutoresizingMaskIntoConstraints=NO;
            [_confirmView addSubview:button];
        }];
        
        NSMutableArray *constraints=[[NSMutableArray alloc]init];
        for (int i=0; i<_clcikHandles.count; i++) {
            UIButton *current=((SYAlertAction *)_clcikHandles[i]).confirmbutton;
            if(i==0)
            {
                if(i==(_clcikHandles.count-1))
                {
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:_confirmView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:current attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
                    
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:_confirmView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:current attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                }else
                {
                    UIButton *nextbutton=((SYAlertAction *)_clcikHandles[i+1]).confirmbutton;
                    
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:_confirmView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:current attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                    
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:current attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:nextbutton attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
                }
            }else if(i==(_clcikHandles.count-1))
            {
                UIButton *prebutton=((SYAlertAction *)_clcikHandles[i-1]).confirmbutton;
                
                [constraints addObject:[NSLayoutConstraint constraintWithItem:prebutton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:current attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
                
                [constraints addObject:[NSLayoutConstraint constraintWithItem:current attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_confirmView attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
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
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end


@interface SYPAlert()
@property(nonatomic,strong)UILabel *titleLable;
@property(nonatomic,strong)UIImageView *refreshImageView;
@property(nonatomic,strong)UIView *backView;
@end
@implementation SYPAlert
-(id)initWithTitle:(NSString *)title
{
    self=[super init];
    if(self)
    {
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        _titleLable=[[UILabel alloc]init];
        [_titleLable setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_titleLable setTextAlignment:NSTextAlignmentLeft];
        [_titleLable setFont:[UIFont systemFontOfSize:20]];
        _titleLable.text=title;
        [_titleLable setTextColor:[UIColor colorWithRed:0.25 green:0.64 blue:1.00 alpha:1.00]];
        
        
        _refreshImageView=[[UIImageView alloc]init];
        [_refreshImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_refreshImageView setImage:[UIImage imageNamed:@"refresh.png"]];
        
        _backView=[[UIView alloc]init];
        [_backView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_backView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_backView];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_backView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:290]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_backView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:55]];
        

        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_backView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_backView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        
    
        [_backView addSubview:_titleLable];
        [_backView addSubview:_refreshImageView];
        NSDictionary *lblDics=NSDictionaryOfVariableBindings(_titleLable,_refreshImageView);
        NSString *lblFormV=@"V:|-0-[_titleLable]-0-|";
        [_backView addConstraint:[NSLayoutConstraint constraintWithItem:_backView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_titleLable attribute:NSLayoutAttributeCenterX multiplier:1 constant:-20]];
        [_backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:lblFormV options:0 metrics:nil views:lblDics]];
        
        NSString *refreshFormH=@"H:[_refreshImageView(25)]-15-[_titleLable]";
        NSString *refreshFormV=@"V:|-15-[_refreshImageView(25)]-15-|";
        
        [_backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:refreshFormH options:0 metrics:nil views:lblDics]];
        [_backView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:refreshFormV options:0 metrics:nil views:lblDics]];
        
    }
    return self;
}
-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if(self.superview)
    {
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self beginAnimation];
    }
}
- (void)removeFromSuperview
{
    [self endAnimation];
    [super removeFromSuperview];
}
-(void)beginAnimation
{
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = MAXFLOAT;
    [_refreshImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}
-(void)endAnimation
{
    [_refreshImageView.layer removeAllAnimations];
}


@end

@interface SYTAlert()
@property(nonatomic,strong)UILabel *titleLable;
@end
@implementation SYTAlert

-(id)initWithTitle:(NSString *)title
{
    self=[super init];
    if(self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        _titleLable=[[UILabel alloc]init];
        [_titleLable setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_titleLable setTextAlignment:NSTextAlignmentLeft];
        [_titleLable setFont:[UIFont systemFontOfSize:20]];
        _titleLable.text=[NSString stringWithFormat:@"  %@  ",title];
        [_titleLable setTextColor:[UIColor whiteColor]];
        [_titleLable setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.9]];
        _titleLable.clipsToBounds=YES;
        _titleLable.layer.cornerRadius=5;
        [self addSubview:_titleLable];
        NSDictionary *dic_title=NSDictionaryOfVariableBindings(_titleLable);
        NSString *VFL_V=@"V:[_titleLable(30)]-(80)-|";
        NSString *VFL_H=@"H:[_titleLable(>=0)]";
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:VFL_H options:NSLayoutFormatAlignAllBaseline metrics:nil views:dic_title]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:VFL_V options:NSLayoutFormatAlignAllBaseline metrics:nil views:dic_title]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_titleLable attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        
        
    }
    return self;
}
-(void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if(self.superview)
    {
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self.superview addConstraint:[NSLayoutConstraint constraintWithItem:self.superview attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    }
}
@end




