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
    
    if(self.animateReclusting){
    // Coming soon is to merge and join annotatoins as the user zooms (like in the Photos app's map view).
    // This commented out code doesn't quite work correctly.
//    if(CGPointEqualToPoint(self.mergeToPoint, CGPointZero)){
        [self animateAdd];
//    } else {
//        [self animateMergeToWithCompletionBlock:^{
//            [super removeFromSuperview];
//        }];
//    }
    }
}

//-(void)removeFromSuperview{
//if(self.animateReclusting){
////    if(CGPointEqualToPoint(self.splitFromPoint, CGPointZero)){
//        [self animateRemoveWithCompletionBlock:^{
//            [super removeFromSuperview];
//        }];
////    } else {
////        [self animateSplitWithCompletionBlock:^{
////            [super removeFromSuperview];
////        }];
////    }
//}
//}


#pragma mark Animations
-(void)animateAdd{
    CGFloat duration = 0.5;
    CGFloat delay = 0;
    double frameDuration = 1.0/5.0; // 4 = number of keyframes
    self.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateKeyframesWithDuration:duration delay:delay options:UIViewKeyframeAnimationOptionCalculationModeCubicPaced animations:^{
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
        self.transform = CGAffineTransformIdentity;
        completionBlock();
    }];
}
-(void)animateSplitWithCompletionBlock:(VWWClusteredAnnotationViewEmptyBlock)completionBlock{

    CGPoint origin = self.frame.origin;
    
    CGPoint splitFromPoint = self.splitFromPoint;
    splitFromPoint.x -= self.frame.size.width / 2.0;
    splitFromPoint.y -= self.frame.size.height / 2.0;
    CGRect startFrame = CGRectMake(splitFromPoint.x, splitFromPoint.y, self.frame.size.width, self.frame.size.height);
    self.frame = startFrame;

    CGRect endFrame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
    
    CGFloat duration = 0.5;
    [UIView animateWithDuration:duration animations:^{
        self.frame = endFrame;
    } completion:^(BOOL finished) {
        completionBlock();
    }];
    
}
-(void)animateMergeToWithCompletionBlock:(VWWClusteredAnnotationViewEmptyBlock)completionBlock{
    CGFloat duration = 0.5;
    
    [UIView animateWithDuration:duration animations:^{
        CGPoint origin = self.frame.origin;
        origin.x += 100;
        self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        completionBlock();
    }];

}

@end
