//
//  ViewController.m
//  FloatView
//
//  Created by 惠上科技 on 2018/12/10.
//  Copyright © 2018 惠上科技. All rights reserved.
//

#import "ViewController.h"
#define FloatScreenWidth  [UIScreen mainScreen].bounds.size.width
#define FloatScreenHeight  [UIScreen mainScreen].bounds.size.height

//悬浮球宽高
#define FloatWidth  60
//悬浮球靠边停留边距
#define FloatMargin 15
//右下角1/4圆半径
#define RoundViewRadius 170

@interface ViewController ()
/**
 悬浮球
 */
@property (nonatomic, strong) UIView *floatView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.floatView];
}


-(UIView *)floatView{
    if (!_floatView) {
        _floatView = [[UIView alloc] initWithFrame:CGRectMake(FloatScreenWidth - FloatWidth - FloatMargin, FloatScreenHeight - RoundViewRadius - FloatWidth, FloatWidth, FloatWidth)];
        _floatView.layer.cornerRadius = 30;
        _floatView.layer.masksToBounds = YES;
        _floatView.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.95];
        //添加拖动手势
        [_floatView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragFloatView:)]];
    }
    return _floatView;
}



-(void)dragFloatView:(UIPanGestureRecognizer *)ges{
    if (ges.state == UIGestureRecognizerStateChanged) {
        CGPoint transitionP = [ges translationInView:ges.view];
        CGFloat transitionX = MAX(FloatWidth / 2.0, MIN(self.floatView.center.x + transitionP.x, FloatScreenWidth - FloatWidth/2.0));
        CGFloat transitionY = MAX(FloatWidth / 2.0, MIN(self.floatView.center.y + transitionP.y, FloatScreenHeight - FloatWidth / 2.0));
        self.floatView.center = CGPointMake(transitionX, transitionY);
        [ges setTranslation:CGPointZero inView:ges.view];
    }else if (ges.state == UIGestureRecognizerStateEnded || ges.state == UIGestureRecognizerStateCancelled){
        [UIView animateWithDuration:0.2 animations:^{
            CGFloat minX = FloatMargin;
            CGFloat maxX = FloatScreenWidth - self.floatView.frame.size.width - FloatMargin;
            CGFloat minY = FloatMargin;
            CGFloat maxY = FloatScreenHeight - self.floatView.frame.size.height - FloatMargin;
            CGPoint point = CGPointZero;
            if (self.floatView.center.x < FloatScreenWidth / 2.0) {
                point.x = minX;
                point.y = MIN(MAX(minY, self.floatView.frame.origin.y), maxY);
            }else{
                point.x = maxX;
                point.y = MIN(MAX(minY, self.floatView.frame.origin.y), maxY);
            }
            CGRect floatRec = self.floatView.frame;
            floatRec.origin = point;
            self.floatView.frame = floatRec;
        }];
    }
}


@end
