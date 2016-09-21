//
//  WSAlertActionView.m
//  WSAlertActionView
//
//  Created by warron on 16/9/21.
//  Copyright © 2016年 warron. All rights reserved.
//

#import "WSAlertActionView.h"
#import <QuartzCore/QuartzCore.h>


#define kAlertWidth 245.0f
#define kAlertHeight 160.0f

@interface WSAlertActionView ()
{
    BOOL _leftLeave;
}

@property (nonatomic, strong) UILabel *alertTitleLabel;
@property (nonatomic, strong) UILabel *alertContentLabel;
@property (nonatomic, strong) UIButton *leftBtn;
@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIView *backImageView;

@end


@implementation WSAlertActionView
+ (CGFloat)alertWidth{
    return kAlertWidth;
}

+ (CGFloat)alertHeight
{
    return kAlertHeight;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#define kTitleYOffset 15.0f
#define kTitleHeight 25.0f

#define kContentOffset 30.0f
#define kBetweenLabelOffset 20.0f


#define kSingleButtonWidth 160.0f
#define kCoupleButtonWidth 107.0f
#define kButtonHeight 40.0f
#define kButtonBottomOffset 10.0f


/**
 *   此类使用说明
 *  1.调用- (id)initWithTitle: contentText: leftOrOneButtonTitle:  rightButtonTitle:创建对象 如 alert
 *  参数1：弹出标题  参数2：内容  参数3：左边按钮标题（传入nil时,不显示，此时用右边按钮创建底部按钮，点击按钮弹框小时，需要处理事件回调，使用alert.rightBlock = ^(){};）参数4：右边按钮标题（传入nil时,不显示，此时用左边按钮创建底部按钮，点击按钮弹框小时，需要处理事件回调，使用alert.leftBlock = ^(){};）
 *
 2.弹框消失 出现时间，摇晃都以默认，可自己分别设置时间
 *
 *   3.调用[alert show()]显示弹框
 *
 *   4.例子    DXAlertView *alert = [[DXAlertView alloc] initWithTitle:@"ABC" contentText:@"好的"  leftOrOneButtonTitle:@"Ok" rightButtonTitle:@"Fine"];
 [alert show];
 alert.leftBlock = ^() {};
 alert.rightBlock = ^() {};
 alert.dismissBlock = ^(){};
 */


//设置公有的属性
-(void)setTitle:(NSString *)title
contentText:(NSString *)content{
    
    //初始化时间
    _slideTime = 0.35;
    _rotationTime = 0.2;
    _isNeedRotaion = YES;
    
    //设置弹出框
    self.layer.cornerRadius = 5.0;
    self.backgroundColor = [UIColor whiteColor];
    
    //设置弹框标题
    _alertTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, kTitleYOffset, kAlertWidth, kTitleHeight)];
    _alertTitleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    _alertTitleLabel.textColor = [UIColor colorWithRed:56.0/255.0 green:64.0/255.0 blue:71.0/255.0 alpha:1];
    [self addSubview:_alertTitleLabel];
    
    //设置弹框内容
    CGFloat contentLabelWidth = kAlertWidth - 16;
    _alertContentLabel = [[UILabel alloc] initWithFrame:CGRectMake((kAlertWidth - contentLabelWidth) * 0.5, CGRectGetMaxY(_alertTitleLabel.frame), contentLabelWidth, 60)];
    _alertContentLabel.numberOfLines = 0;
    _alertContentLabel.textAlignment = _alertTitleLabel.textAlignment = NSTextAlignmentCenter;
    _alertContentLabel.textColor = [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1];
    _alertContentLabel.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:_alertContentLabel];
    
    //设置 “ X ” 按钮
    UIButton *xButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [xButton setImage:[UIImage imageNamed:@"btn_close_normal.png"] forState:UIControlStateNormal];
    [xButton setImage:[UIImage imageNamed:@"btn_close_selected.png"] forState:UIControlStateHighlighted];
    xButton.frame = CGRectMake(kAlertWidth - 32, 0, 32, 32);
    [self addSubview:xButton];
    
    [xButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
    
    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    
    
    _alertTitleLabel.text = title;
    _alertContentLabel.text = content;
}

- (id)initWithTitle:(NSString *)title
contentText:(NSString *)content
leftOrOneButtonTitle:(NSString *)leftTitle
rightButtonTitle:(NSString *)rigthTitle{
    
    if (self = [super init]) {
        
        [self setTitle:title contentText:content];
        
        //设置底部两个按钮
        CGRect leftBtnFrame;
        CGRect rightBtnFrame;
        
        //如果左边title为空，就只设置一个按钮
        if (!leftTitle) {
            //点击按钮的回调用 rightBlock
            rightBtnFrame = CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kSingleButtonWidth, kButtonHeight);
            _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _rightBtn.frame = rightBtnFrame;
            
        }
        //如果右边边title为空，就只设置一个按钮
        else if (!rigthTitle) {
            
            //点击按钮的回调用 leftBlock
            leftBtnFrame = CGRectMake((kAlertWidth - kSingleButtonWidth) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kSingleButtonWidth, kButtonHeight);
            _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _leftBtn.frame = leftBtnFrame;
        }
        
        else {
            leftBtnFrame = CGRectMake((kAlertWidth - 2 * kCoupleButtonWidth - kButtonBottomOffset) * 0.5, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            rightBtnFrame = CGRectMake(CGRectGetMaxX(leftBtnFrame) + kButtonBottomOffset, kAlertHeight - kButtonBottomOffset - kButtonHeight, kCoupleButtonWidth, kButtonHeight);
            _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _leftBtn.frame = leftBtnFrame;
            _rightBtn.frame = rightBtnFrame;
        }
        
        //批量设置左右按钮属性
        [_rightBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:87.0/255.0 green:135.0/255.0 blue:173.0/255.0 alpha:1]] forState:UIControlStateNormal];
        [_leftBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:227.0/255.0 green:100.0/255.0 blue:83.0/255.0 alpha:1]] forState:UIControlStateNormal];
        [_rightBtn setTitle:rigthTitle forState:UIControlStateNormal];
        [_leftBtn setTitle:leftTitle forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = self.rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //添加左右按钮点击事件
        [_leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _leftBtn.layer.masksToBounds = _rightBtn.layer.masksToBounds = YES;
        _leftBtn.layer.cornerRadius = _rightBtn.layer.cornerRadius = 3.0;
        [self addSubview:_leftBtn];
        [self addSubview:_rightBtn];
        
    }
    return self;
}

- (void)leftBtnClicked:(id)sender
{
    _leftLeave = YES;
    [self dismissAlert];
    if (self.leftBlock) {
        self.leftBlock();
    }
}

- (void)rightBtnClicked:(id)sender
{
    _leftLeave = NO;
    [self dismissAlert];
    if (self.rightBlock) {
        self.rightBlock();
    }
}

- (void)dismissAlert
{
    [self removeFromSuperview];
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    
}


- (void)show
{
    UIViewController *topVC = [self appRootViewController];
    self.frame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, - kAlertHeight - 30, kAlertWidth, kAlertHeight);
    [topVC.view addSubview:self];
}


- (UIViewController *)appRootViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}


- (void)removeFromSuperview{
    
    [self.backImageView removeFromSuperview];
    self.backImageView = nil;
    UIViewController *topVC = [self appRootViewController];
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, CGRectGetHeight(topVC.view.bounds), kAlertWidth, kAlertHeight);
    
    [UIView animateWithDuration:_slideTime delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.frame = afterFrame;
        if (_leftLeave) {
            self.transform = CGAffineTransformMakeRotation(-M_1_PI / 1.5);
        }else {
            self.transform = CGAffineTransformMakeRotation(M_1_PI / 1.5);
        }
    } completion:^(BOOL finished) {
        [super removeFromSuperview];
    }];
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (newSuperview == nil) {
        return;
    }
    UIViewController *topVC = [self appRootViewController];
    
    if (!_backImageView) {
        
        _backImageView = [[UIView alloc] initWithFrame:topVC.view.bounds];
        
        _backImageView.backgroundColor = [UIColor blackColor];
        
        _backImageView.alpha = 0.6f;
        
        _backImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    }
    [topVC.view addSubview:self.backImageView];
    
    self.transform = CGAffineTransformMakeRotation(-M_1_PI / 2);
    
    CGRect afterFrame = CGRectMake((CGRectGetWidth(topVC.view.bounds) - kAlertWidth) * 0.5, (CGRectGetHeight(topVC.view.bounds) - kAlertHeight) * 0.5, kAlertWidth, kAlertHeight);
    //开始一个动画
    [UIView animateWithDuration:_slideTime delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
        self.frame = afterFrame;
        
    } completion:^(BOOL finished) {
        
        if (finished && _isNeedRotaion) {
            
            //结束后 判断一下是否 再来一个左右摇摆的动画 开始
            [UIView animateWithDuration:_rotationTime delay:0 options:UIViewAnimationOptionAllowAnimatedContent|  UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                 //摇摆弧度
                                 self.transform   =CGAffineTransformMakeRotation(0.1);
                             } completion:^(BOOL finished) {
                                 //复位
                                 self.transform   =CGAffineTransformMakeRotation(0);
                             }];
            
        }
        //结束
        
    }];
    
    [super willMoveToSuperview:newSuperview];
}

@end

@implementation UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

