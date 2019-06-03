//
//  XGYProgressLayer.m
//  XGYPhotoBrowser
//
//  Created by guoyong xu on 30/12/2016.
//  Copyright © 2016 guoyong xu. All rights reserved.
//

#import "XGYLoadingProgressLayer.h"

@interface XGYLoadingProgressLayer ()<CAAnimationDelegate>

@property (nonatomic, assign) BOOL isSpinning;

@end

@implementation XGYLoadingProgressLayer

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super init];
    if (self) {
        self.frame = frame;
        self.cornerRadius = 20;
        self.fillColor = [UIColor clearColor].CGColor;
        self.strokeColor = [UIColor whiteColor].CGColor;
        self.lineWidth = 4;
        self.lineCap = kCALineCapRound;
        self.strokeStart = 0;
        self.strokeEnd = 0.01;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5].CGColor;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, 2, 2) cornerRadius:20-2];
        self.path = path.CGPath;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {
    if (self.isSpinning) {
        [self xgy_startAnimation];
    }
}

- (void)xgy_startAnimation {
    self.isSpinning = YES;
    [self spinWithAngle:M_PI];
}

- (void)spinWithAngle:(CGFloat)angle {
    self.strokeEnd = 0.33;
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI-0.5);
    rotationAnimation.duration = 0.4;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE;
    [self addAnimation:rotationAnimation forKey:nil];
}

- (void)xgy_stopAnimation {
    self.isSpinning = NO;
    [self removeAllAnimations];
}

+ (void)showMessage:(NSString *)message
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
    label.backgroundColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.layer.cornerRadius = 5.0f;
    label.layer.masksToBounds = YES;
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    [keywindow addSubview:label];
    label.text = message;
    CGSize sizeFit = [message boundingRectWithSize:CGSizeMake(MAXFLOAT, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :label.font} context:nil].size;
    label.frame = CGRectMake(0, 0, sizeFit.width + 10, sizeFit.height + 10);
    label.center = keywindow.center;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [label removeFromSuperview];
    });
}


@end
