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
//    if(CGPointEqualToPoint(self.mergeToPoint, CGPointZero)){
        [self animateAdd];
//    } else {
//        [self animateMergeToWithCompletionBlock:^{
//            [super removeFromSuperview];
//        }];
//    }
}

//-(void)removeFromSuperview{
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
    
//    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    
//    bounceAnimation.values = @[@(0.05), @(1.5), @(0.7), @(1)];
//    
//    bounceAnimation.duration = 0.6;
//    NSMutableArray *timingFunctions = [[NSMutableArray alloc] initWithCapacity:bounceAnimation.values.count];
//    for (NSUInteger i = 0; i < bounceAnimation.values.count; i++) {
//        [timingFunctions addObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
//    }
//    [bounceAnimation setTimingFunctions:timingFunctions.copy];
//    bounceAnimation.removedOnCompletion = NO;
//    
//    [view.layer addAnimation:bounceAnimation forKey:@"bounce"];
}

-(void)animateRemoveWithCompletionBlock:(VWWClusteredAnnotationViewEmptyBlock)completionBlock{
    CGFloat duration = 0.5;
    
    [UIView animateWithDuration:duration animations:^{
//        self.transform = CGAffineTransformMakeScale(0.001, 0.001);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
//        self.transform = CGAffineTransformIdentity;
        self.alpha = 1.0;
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
    
//    if(!CGRectEqualToRect(startFrame, endFrame)){
//        NSLog(@"----------------------------------------------------------------");
//        NSLog(@"start: %@", NSStringFromCGRect(startFrame));
//        NSLog(@"end  : %@", NSStringFromCGRect(endFrame));
//    }
    
    
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
//        self.center = self.mergeToPoint;
//        self.center = CGPointMake(self.center.x + 100, self.center.y);
        CGPoint origin = self.frame.origin;
        origin.x += 100;
        self.frame = CGRectMake(origin.x, origin.y, self.frame.size.width, self.frame.size.height);
    } completion:^(BOOL finished) {
        completionBlock();
    }];

}

//-(void)test{
//    NSSet *annotationStacks = [NSSet setWithArray:annotation.stacks];
//    __block BOOL foundInLastAnnotations = NO;
//    for(VWWClusterAnnotation *lastAnnotation in self.lastAnnotations){
//        if([lastAnnotation isKindOfClass:[VWWClusterAnnotation class]]){
//            NSSet *lastAnnotationStacks = [NSSet setWithArray:lastAnnotation.stacks];
//            
//            if([annotationStacks isSubsetOfSet:lastAnnotationStacks]){
//                foundInLastAnnotations = YES;
//                CGPoint fromPoint = [self.mapView convertCoordinate:lastAnnotation.coordinate toPointToView:self.view];
//                annotationView.center = fromPoint;
//                CGPoint toPoint = [self.mapView convertCoordinate:annotation.coordinate toPointToView:self.view];
//                //                [UIView animateWithDuration:0.3 animations:^{
//                [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                    annotationView.center = toPoint;
//                } completion:^(BOOL finished) {
//                    
//                }];
//                break;
//            }
//        }
//    }
//    
//    if(foundInLastAnnotations == NO){
//        [self addBounceAnnimationToView:annotationView];
//    }
//}

@end
