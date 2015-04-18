//
//  VWWClusteredAnnotationView.m
//  VWWClusteredMapViewExample
//
//  Created by Zakk Hoyt on 4/17/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWClusteredAnnotationView.h"
#import "VWWClusteredAnnotation.h"

typedef void(^VWWClusteredAnnotationViewEmptyBlock)(void);

@implementation VWWClusteredAnnotationView


-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    VWWClusteredAnnotation *annoation = (VWWClusteredAnnotation*)self.annotation;
    if(CGPointEqualToPoint(annoation.splitFromPoint, CGPointZero)){
        [self animateAdd];
    } else {
        [self animateSplitFromAnnotation];
    }
}

-(void)removeFromSuperview{
    [self animateRemoveWithCompletionBlock:^{
        [super removeFromSuperview];
    }];
}


#pragma mark Animations
-(void)animateAdd{
    CGFloat duration = 0.5;
    CGFloat delay = 0;
    double frameDuration = 1.0/5.0; // 4 = number of keyframes
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateKeyframesWithDuration:duration delay:delay options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        [UIView addKeyframeWithRelativeStartTime:0*frameDuration relativeDuration:frameDuration animations:^{
            self.transform = CGAffineTransformMakeScale(0.05, 0.05);
        }];
        [UIView addKeyframeWithRelativeStartTime:1*frameDuration relativeDuration:frameDuration animations:^{
            self.transform = CGAffineTransformMakeScale(1.5, 1.5);
        }];
        [UIView addKeyframeWithRelativeStartTime:2*frameDuration relativeDuration:frameDuration animations:^{
            self.transform = CGAffineTransformMakeScale(0.9, 0.9);
        }];
        [UIView addKeyframeWithRelativeStartTime:3*frameDuration relativeDuration:frameDuration animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    } completion:nil];
}

-(void)animateRemoveWithCompletionBlock:(VWWClusteredAnnotationViewEmptyBlock)completionBlock{
    CGFloat duration = 0.5;
    
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeScale(0.001, 0.001);
    } completion:^(BOOL finished) {
        completionBlock();
    }];
}
-(void)animateSplitFromAnnotation{
    
    CGPoint point = self.center;
    VWWClusteredAnnotation *annoation = (VWWClusteredAnnotation*)self.annotation;
    self.center = annoation.splitFromPoint;
    
    CGFloat duration = 0.5;
    [UIView animateWithDuration:duration animations:^{
        self.center = point;
    } completion:^(BOOL finished) {

    }];
    
}
-(void)animateMergeToAnnotationView:(VWWClusteredAnnotationView*)toAnnotationView{
    
}

@end
