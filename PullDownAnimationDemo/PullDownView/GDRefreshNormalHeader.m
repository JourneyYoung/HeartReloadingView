//
//  GDRefreshNormalHeader.m
//  IGReport
//
//  Created by Journey on 2018/1/8.
//  Copyright © 2018年 GoDap. All rights reserved.
//

#import "GDRefreshNormalHeader.h"
#import "GDRefreshAnimationView.h"

@interface GDRefreshNormalHeader ()<UIScrollViewDelegate>

@property (nonatomic, strong) GDRefreshAnimationView *freshView;

@property (nonatomic, assign) CGFloat lastPersent;

@end

@implementation GDRefreshNormalHeader



- (void)placeSubviews{
    [super placeSubviews];
    for(UIView *view in self.subviews){
        if([view isKindOfClass:[UIActivityIndicatorView class]]){
            [view removeFromSuperview];
            break;
        }
    }
    self.freshView.backgroundColor = [UIColor clearColor];
    self.stateLabel.alpha = 0;
    self.lastUpdatedTimeLabel.alpha = 0;
    self.arrowView.alpha = 0;
    [self addSubview:self.freshView];
}

-(void)scrollViewContentOffsetDidChange:(NSDictionary *)change{
    [super scrollViewContentOffsetDidChange:change];
    if(self.state == MJRefreshStateRefreshing){
        self.freshView.alpha = 1;
        return;
    }
    NSLog(@"%@",change);
    CGFloat k = self.pullingPercent-self.lastPersent;
    self.freshView.alpha = self.pullingPercent * 2;
    self.lastPersent = self.pullingPercent;
    [self.freshView changePoint:k*10];
}

-(void)beginRefreshing{
    [super beginRefreshing];
    self.freshView.alpha = 1;
    [self.freshView startAnimation];
}

- (void)endRefreshing{
    [super endRefreshing];
    [self.freshView animationStopAnimation];
}

- (GDRefreshAnimationView *)freshView{
    if(!_freshView){
        _freshView = [[GDRefreshAnimationView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.5-50, self.arrowView.mj_y, 100, 60)];
    }
    return _freshView;
}

@end
