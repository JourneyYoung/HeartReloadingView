//
//  GDRefreshAnimationView.h
//  IGReport
//
//  Created by Journey on 2018/1/8.
//  Copyright © 2018年 GoDap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GDRefreshAnimationView : UIView

- (void)changePoint:(CGFloat)key;

- (void)startAnimation;

- (void)stopAnimation;

- (void)animationStopAnimation;

@end
