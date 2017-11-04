//
//  INKThreeAnimationView.m
//  INKSDK
//
//  Created by CreditPayHome on 2017/4/12.
//  Copyright © 2017年 CreditPayHome. All rights reserved.
//

#import "INKThreeAnimationView.h"

// 第一、二阶段的动画执行时间
#define FIRSTDURATION 2
#define SECONDDURATION 2


@interface INKThreeAnimationView () <CALayerDelegate>
@property (strong, nonatomic) CALayer *oneLayer;
@property (strong, nonatomic) CALayer *twoLayer;
@property (strong, nonatomic) NSMutableArray *marr;
@property (strong, nonatomic) UIColor *lineColor;
@property (strong, nonatomic) UIColor *myBackgroundColor;
@property (assign, nonatomic) BOOL canReplay;
@end


@implementation INKThreeAnimationView

- (instancetype _Nullable)initWithFrame:(CGRect)frame imageArr:(NSArray <UIImage *>*_Nullable)imageArr backgroundColor:(UIColor *_Nullable)backgroundColor lineColor:(UIColor *_Nullable)lineColor radius:(const CGFloat* _Nullable )radius count:(size_t)count
{
    self = [super initWithFrame:frame];
    if (self) {
        _myBackgroundColor = backgroundColor;
        _lineColor = lineColor;
        [self createUIWithImageArr:imageArr radius:radius count:count];
    }
    return self;
}

#pragma mark - 创建UI
-(void)createUIWithImageArr:(NSArray *_Nullable)imageArr radius:(const CGFloat* _Nullable)radius count:(size_t)count{

    if (count != 3) {
        return;
    }
    if (imageArr.count != 4) {
        return;
    }
    for (int i = 0; i < imageArr.count; i++) {
        if (![imageArr[i] isMemberOfClass:[UIImage class]]) {
            return;
        }
    }

    _canReplay = YES;
    // CALayer 的边色 会覆盖 子CALyer 的 内容👇
    UIView *V = [[UIView alloc] initWithFrame:CGRectMake(0, 0, radius[0]*2, radius[0]*2)];
    V.backgroundColor = _myBackgroundColor;
    V.layer.cornerRadius = V.bounds.size.width/2;
    V.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self addSubview:V];
    
    _oneLayer = [CALayer layer];
    _oneLayer.backgroundColor = _myBackgroundColor.CGColor;
    _oneLayer.frame = CGRectMake(0, 0, radius[1]*2, radius[1]*2);
    _oneLayer.position = CGPointMake(V.bounds.size.width/2, V.bounds.size.height/2);
    _oneLayer.masksToBounds = YES;
    _oneLayer.hidden = YES;
    _oneLayer.cornerRadius = _oneLayer.bounds.size.height/2;
    _oneLayer.contentsGravity = kCAGravityResizeAspectFill;
    UIImage *image = imageArr[3];
    _oneLayer.contents = (__bridge id _Nullable)image.CGImage;
    
    _twoLayer = [CALayer layer];
    _twoLayer.frame = V.bounds;
    _twoLayer.hidden = YES;
    _twoLayer.position = CGPointMake(V.bounds.size.width/2, V.bounds.size.height/2);
    _twoLayer.cornerRadius = _twoLayer.bounds.size.height/2;
    
    [V.layer addSublayer:_oneLayer];
    [V.layer addSublayer:_twoLayer];
    
    
    
    CALayer *backgroundLayer = [CALayer layer];
    backgroundLayer.frame = _twoLayer.bounds;
    backgroundLayer.cornerRadius = _twoLayer.bounds.size.height/2;
    backgroundLayer.borderColor = _lineColor.CGColor;
    backgroundLayer.borderWidth = 1.0f;
    [_twoLayer addSublayer:backgroundLayer];
    
    
    _marr = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        CALayer *layerO = [CALayer layer];
        layerO.frame = CGRectMake(0, 0, radius[2]*2, radius[2]*2);
        layerO.position = _twoLayer.position;
        layerO.backgroundColor = _myBackgroundColor.CGColor;
        layerO.masksToBounds = YES;
        layerO.cornerRadius = layerO.bounds.size.width/2;
        layerO.delegate = self;
        [layerO display];
        
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, layerO.bounds.size.width-10.0f, layerO.bounds.size.height-10.0f);
        layer.position = CGPointMake(layerO.bounds.size.width/2, layerO.bounds.size.height/2);
        layer.masksToBounds = YES;
        layer.cornerRadius = layer.bounds.size.width/2;
        layer.contentsGravity = kCAGravityResize;
        UIImage *image = imageArr[i];
        layer.contents = (__bridge id _Nullable)image.CGImage;
        
        [layerO addSublayer:layer];
        [_twoLayer addSublayer:layerO];
        [_marr addObject:layerO];
    }
    
}


-(void)hideOneLayer{
    if (!_oneLayer.isHidden) {
        _oneLayer.hidden = YES;
    }
}
-(void)displayOneLayer{
    _canReplay = YES;
    if (_oneLayer.isHidden) {
        _oneLayer.hidden = NO;
    }
}
-(void)displayTwoLayer{
    if (_twoLayer.isHidden) {
        _twoLayer.hidden = NO;
    }
}


#pragma mark - 启动动画
-(void)playAnimation{
    if (_canReplay) {
        [self hideOneLayer];
        [self displayTwoLayer];
        [self addAnimationA];
        [self addAnimationB];
        [self addAnimationC];
    }
}

#pragma mark - 动画
-(void)addAnimationA{
    _canReplay = NO;
    [self performSelector:@selector(displayOneLayer) withObject:nil afterDelay:FIRSTDURATION];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath= @"transform.scale";
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(1);
    basicAnimation.duration = 1;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    basicAnimation.beginTime = CACurrentMediaTime() + FIRSTDURATION;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    [_oneLayer addAnimation:basicAnimation forKey:nil];
}

-(void)addAnimationB{
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath= @"transform.rotation.z";
    basicAnimation.fromValue = @(0);
    basicAnimation.toValue = @(M_PI);
    basicAnimation.duration = 1.5;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    basicAnimation.beginTime = CACurrentMediaTime();
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [_twoLayer addAnimation:basicAnimation forKey:nil];
    
    CABasicAnimation *basicAnimation1 = [CABasicAnimation animation];
    basicAnimation1.keyPath= @"transform.rotation.z";
    basicAnimation1.fromValue = @(0);
    basicAnimation1.toValue = @(-M_PI);
    basicAnimation1.duration = FIRSTDURATION;
    basicAnimation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    basicAnimation1.beginTime = CACurrentMediaTime();
    basicAnimation1.removedOnCompletion = NO;
    basicAnimation1.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *basicAnimation2 = [CABasicAnimation animation];
    basicAnimation2.keyPath= @"transform.scale";
    basicAnimation2.fromValue = @(0);
    basicAnimation2.toValue = @(1);
    basicAnimation2.duration = 1.5;
    basicAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    basicAnimation2.beginTime = CACurrentMediaTime();
    basicAnimation2.removedOnCompletion = NO;
    basicAnimation2.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *basicAnimation3 = [CABasicAnimation animation];
    basicAnimation3.keyPath= @"position";
    basicAnimation3.fromValue = [NSValue valueWithCGPoint:CGPointMake(_twoLayer.bounds.size.width/2, _twoLayer.bounds.size.height/2)];
    basicAnimation3.duration = 1.5;
    basicAnimation3.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    basicAnimation3.beginTime = CACurrentMediaTime();
    basicAnimation3.removedOnCompletion = NO;
    basicAnimation3.fillMode = kCAFillModeForwards;
    
    for (int i = 0; i < _marr.count; i++) {
        if (i == 0) {
            basicAnimation3.toValue = [NSValue valueWithCGPoint:CGPointMake(_twoLayer.bounds.size.width/2, 0)];
        }else if (i == 1 || i == 2){
            basicAnimation3.toValue = [NSValue valueWithCGPoint:CGPointMake(_twoLayer.bounds.size.width/2+_twoLayer.bounds.size.width/2*cos(M_PI/6*i + M_PI_2*(i-1)), _twoLayer.bounds.size.width/2+_twoLayer.bounds.size.width/2*cos(M_PI/3))];
        }
        
        [(CALayer *)_marr[i] addAnimation:basicAnimation1 forKey:nil];
        [(CALayer *)_marr[i] addAnimation:basicAnimation2 forKey:nil];
        [(CALayer *)_marr[i] addAnimation:basicAnimation3 forKey:nil];
    }
    
}

-(void)addAnimationC{
    CABasicAnimation *basicAnimation = [CABasicAnimation animation];
    basicAnimation.keyPath= @"transform.rotation.z";
    basicAnimation.fromValue = @(M_PI);
    basicAnimation.toValue = @(M_PI*9/4);
    basicAnimation.duration = SECONDDURATION;
    basicAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    basicAnimation.beginTime = CACurrentMediaTime()+FIRSTDURATION;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    [_twoLayer addAnimation:basicAnimation forKey:nil];
    
    
    CABasicAnimation *basicAnimationO = [CABasicAnimation animation];
    basicAnimationO.keyPath= @"transform.rotation.z";
    basicAnimationO.fromValue = @(-M_PI);
    basicAnimationO.toValue = @(-M_PI*9/4);
    basicAnimationO.duration = SECONDDURATION;
    basicAnimationO.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    basicAnimationO.beginTime = CACurrentMediaTime()+FIRSTDURATION;
    basicAnimationO.removedOnCompletion = NO;
    basicAnimationO.fillMode = kCAFillModeForwards;
    
    for (int i = 0; i < _marr.count; i++) {
        [(CALayer *)_marr[i] addAnimation:basicAnimationO forKey:nil];
    }
}

#pragma mark - CALayerDelegate
-(void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx{
    CGContextSetLineWidth(ctx, 1.5f);
    CGFloat lengths[] = {5, 5};
    CGContextSetLineDash(ctx, 0, lengths, 2);
    CGContextSetStrokeColorWithColor(ctx, _lineColor.CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
}


@end
