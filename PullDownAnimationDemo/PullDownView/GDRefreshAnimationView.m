//
//  GDRefreshAnimationView.m
//  IGReport
//
//  Created by Journey on 2018/1/8.
//  Copyright © 2018年 GoDap. All rights reserved.
//

#import "GDRefreshAnimationView.h"
#import "GCDTimer.h"
#import "GCDQueue.h"

static const CGFloat kPointY = 40.f;

@interface GDRefreshAnimationView ()

@property (nonatomic, assign) CGPoint firstLine;

@property (nonatomic, assign) CGPoint secondLine;

@property (nonatomic, assign) CGPoint thirdLine;

@property (nonatomic, assign) CGPoint forthLine;

@property (nonatomic, assign) CGPoint fifthLine;

@property (nonatomic, assign) CGPoint sixLine;

@property (nonatomic, assign) CGPoint sevenline;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, strong) CAShapeLayer *animationLayer;

@property (nonatomic, strong) GCDTimer *timer;

@property (nonatomic, assign) BOOL isAnimation;

@property (nonatomic, strong) NSTimer *kTimer;

@property (nonatomic, assign) CGFloat num;

@end

@implementation GDRefreshAnimationView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.num = 0.0f;
        self.isAnimation = NO;
        [self setPoint];
        
        self.shapeLayer = [CAShapeLayer layer];
        [self.layer addSublayer:self.shapeLayer];
        self.shapeLayer.frame = CGRectMake(self.frame.size.width*0.5-48, self.frame.size.height*0.5-12, 100, 60);
        self.shapeLayer.fillColor   = [UIColor clearColor].CGColor;
        self.shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        self.shapeLayer.lineWidth   = 4.f;
        self.shapeLayer.lineJoin = kCALineCapRound;
        self.shapeLayer.lineCap = kCALineCapRound;
        self.shapeLayer.shadowColor = [UIColor whiteColor].CGColor;
        [self.shapeLayer setTransform:CATransform3DMakeScale(0.5, 0.5, 1.f)];
        
        
        self.animationLayer = [CAShapeLayer layer];
        self.animationLayer.frame         = CGRectMake(self.frame.size.width*0.5-48, self.frame.size.height*0.5-12, 100, 60);
        
        self.animationLayer.fillColor   = [UIColor clearColor].CGColor;
        self.animationLayer.strokeColor = [UIColor whiteColor].CGColor;
        self.animationLayer.lineWidth   = 10.f;
        self.animationLayer.lineJoin = kCALineCapRound;
        self.animationLayer.lineCap = kCALineCapRound;
        self.animationLayer.shadowColor = [UIColor whiteColor].CGColor;
        [self.animationLayer setTransform:CATransform3DMakeScale(0.5, 0.5, 1.f)];
        
        
        UIGraphicsBeginImageContext(self.bounds.size);
        self.shapeLayer.path          = [self path].CGPath;
        UIGraphicsEndImageContext();
    }
    return self;
}

///缓慢动画复位
- (void)animationStopAnimation{
    [self.animationLayer removeAllAnimations];
    _kTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
    [_kTimer fire];
}

- (void)timeAction{
    if(self.num >100){
        self.alpha = 0;
        self.num = 0.0f;
        [self.kTimer invalidate];
        self.kTimer = nil;
        [self stopAnimation];
    }
    [self.animationLayer removeAllAnimations];
    self.alpha -= 0.3;
    [self changePoint:(-0.4)];
    self.num += 1.0f;
}

- (void)stopAnimation{
    [self.timer destroy];
    [self.animationLayer removeAllAnimations];
    
    ///恢复原状
    [self setPoint];
    UIGraphicsBeginImageContext(self.bounds.size);
    self.shapeLayer.path          = [self path].CGPath;
    UIGraphicsEndImageContext();
    
}

- (void)startAnimation{
    if(self.fifthLine.y == kPointY){
        ///防止心脏停跳的情况出现
        
    }
    ///容错
    [self setStaticPoint];
    self.alpha = 1;
    
    CGFloat MAX = 1.0f;
    CGFloat GAP = 0.02;
    
    UIGraphicsBeginImageContext(self.bounds.size);
    self.animationLayer.path          = self.shapeLayer.path;
    UIGraphicsEndImageContext();
    
    
    self.timer = [[GCDTimer alloc] initInQueue:[GCDQueue mainQueue]];
    [self.timer event:^{
        [self.layer addSublayer:self.animationLayer];
        CABasicAnimation *aniStart = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        aniStart.fromValue         = [NSNumber numberWithFloat:0.f];
        aniStart.toValue           = [NSNumber numberWithFloat:MAX];
        aniStart.duration          = 1.f;
        
        CABasicAnimation *aniEnd   = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        aniEnd.fromValue           = [NSNumber numberWithFloat:0.f + GAP];
        aniEnd.toValue             = [NSNumber numberWithFloat:MAX + GAP];
        aniEnd.duration            = 1.f;
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration          = 4.9f;
        group.animations        = @[aniEnd, aniStart];
        
        self.animationLayer.strokeStart   = MAX;
        self.animationLayer.strokeEnd     = MAX + GAP;
        [self.animationLayer addAnimation:group forKey:nil];
        
    } timeIntervalWithSecs:1.2f delaySecs:0.f];
    [self.timer start];
}

//- (void)setUpShapeLayer{
//    self.shapeLayer = [GDLineShapeLayer layer];
//    self.shapeLayer.frame         = CGRectMake(self.frame.size.width*0.5-48, self.frame.size.height*0.5-12, 100, 60);
//    self.shapeLayer.path          = [self path].CGPath;
//
//    self.shapeLayer.fillColor   = [UIColor clearColor].CGColor;
//    self.shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
//    self.shapeLayer.lineWidth   = 4.f;
//    //    self.shapeLayer.position    = CGPointMake(self.frame.size.width-88, self.frame.size.height);
//    self.shapeLayer.lineJoin = kCALineCapRound;
//    self.shapeLayer.lineCap = kCALineCapRound;
//    self.shapeLayer.shadowColor = [UIColor whiteColor].CGColor;
//    [self.shapeLayer setTransform:CATransform3DMakeScale(0.5, 0.5, 1.f)];
//
//    [self.layer addSublayer:self.shapeLayer];
//}

///一次加0.1，key=2.5最OK
- (void)changePoint:(CGFloat)key{
    if([self changePointY:_fifthLine andKey:(0-key)*2].y<(kPointY - 28) ||[self changePointY:_fifthLine andKey:(0-key)*2].y>kPointY){
        return;
    }
    ///线条变化时先停止动画
    NSLog(@"_________%f",key);
    
    
    ///第二个点不动
    self.firstLine = [self changePointX:_firstLine andKey:key*0.2];
    self.secondLine = [self changePointX:_secondLine andKey:key*0.1];
    self.thirdLine = [self changePointY:_thirdLine andKey:(0-key)];
    self.forthLine = [self changePointX:_forthLine andKey:key*0.2];
    self.forthLine = [self changePointY:_forthLine andKey:key];
    self.fifthLine = [self changePointX:_fifthLine andKey:key*0.3];
    self.fifthLine = [self changePointY:_fifthLine andKey:(0-key)*2];
    self.sixLine = [self changePointX:_sixLine andKey:key*0.5];
    self.sevenline = [self changePointX:_sevenline andKey:(0-key)*0.1];

    UIGraphicsBeginImageContext(self.bounds.size);
    self.shapeLayer.path          = [self path].CGPath;
    UIGraphicsEndImageContext();
}

- (UIBezierPath *)path{
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:_firstLine];
    [bezierPath addLineToPoint:_secondLine];
    [bezierPath addLineToPoint:_thirdLine];
    [bezierPath addLineToPoint:_forthLine];
    [bezierPath addLineToPoint:_fifthLine];
    [bezierPath addLineToPoint:_sixLine];
    [bezierPath addLineToPoint:_sevenline];
    bezierPath.lineJoinStyle = kCGLineJoinBevel;
    
    [UIColor.blackColor setStroke];
    bezierPath.lineWidth = 4;
    [bezierPath stroke];
    
    return bezierPath;
}

- (CGPoint)changePointX:(CGPoint)point andKey:(CGFloat)key{
    CGFloat x = point.x;
    return CGPointMake(x+key, point.y);
}

- (CGPoint)changePointY:(CGPoint)point andKey:(CGFloat)key{
    CGFloat y = point.y;
    return CGPointMake(point.x, y+key);
}

- (void)setPoint{
    self.firstLine = CGPointMake(0, kPointY);
    self.secondLine = CGPointMake(9, kPointY);
    self.thirdLine = CGPointMake(18, kPointY);
    self.forthLine = CGPointMake(32, kPointY);
    self.fifthLine = CGPointMake(47, kPointY);
    self.sixLine = CGPointMake(60, kPointY);
    self.sevenline = CGPointMake(92, kPointY);
}

- (void)setStaticPoint{
    ///先移除定时器
    [self.kTimer invalidate];
    self.kTimer = nil;
    self.firstLine = CGPointMake(2.8, kPointY);
    self.secondLine = CGPointMake(10.4, kPointY);
    self.thirdLine = CGPointMake(18, kPointY-14);
    self.forthLine = CGPointMake(34.8, kPointY+14);
    self.fifthLine = CGPointMake(52.2, kPointY-28);
    self.sixLine = CGPointMake(67, kPointY);
    self.sevenline = CGPointMake(90.6, kPointY);
    
    
    UIGraphicsBeginImageContext(self.bounds.size);
    self.shapeLayer.path          = [self path].CGPath;
    UIGraphicsEndImageContext();
    
}

- (void)drawRect:(CGRect)rect{
    NSLog(@"%d",self.layer.sublayers.count);
//    self.shapeLayer.path          = [self path].CGPath;
}


@end
