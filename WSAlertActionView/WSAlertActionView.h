//
//  WSAlertActionView.h
//  WSAlertActionView
//
//  Created by warron on 16/9/21.
//  Copyright © 2016年 warron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSAlertActionView : UIView


- (id)initWithTitle:(NSString *)title
        contentText:(NSString *)content
leftOrOneButtonTitle:(NSString *)leftTitle
   rightButtonTitle:(NSString *)rigthTitle;


- (void)show;



//dispatch_async(dispatch_queue_t queue, dispatch_block_t block);
//
//在给定的调度队列中，异步执行相应的代码块。
//dispatch_block_t代码块格式为：void (^dispatch_block_t)(void)
//这里的Block实际上就是dispatch_async 中的block
@property (nonatomic, copy) dispatch_block_t leftBlock;
@property (nonatomic, copy) dispatch_block_t rightBlock;
@property (nonatomic, copy) dispatch_block_t dismissBlock;

//出现 消失所用时间
@property (nonatomic,assign)CGFloat  slideTime;

//摇晃时间
@property (nonatomic,assign)CGFloat  rotationTime;

//是否需要左右摇晃效果
@property (nonatomic,assign)BOOL isNeedRotaion;
@end

@interface UIImage (colorful)

+ (UIImage *)imageWithColor:(UIColor *)color;
@end
