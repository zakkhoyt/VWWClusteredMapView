//
//  ClusteredMapView+Private.m
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWClusteredMapView+Private.h"
#import "VWWClusteredMapView+ClassExtension.h"
#import "VWWClusteredAnnotation.h"
#import "VWWClusteredAnnotationView.h"

@implementation VWWClusteredMapView (Private)

- (void)refreshClusterableAnnotations {
    //    if ([self.lock tryLock]) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        NSMutableSet *before = self.clusteredAnnotations;
        self.lastClusteredAnnotations = [NSSet setWithSet:before];

        double scale = self.bounds.size.width / self.visibleMapRect.size.width;
        NSArray *currentAnnotations = [self.quadTree clusteredAnnotationsWithinMapRect:self.visibleMapRect withZoomScale:scale];

        if (currentAnnotations.count == 0 && self.lastClusteredAnnotations.count == 0) {
            //                [self.lock unlock];
            return;
        }

        NSMutableSet *after = [NSMutableSet setWithArray:currentAnnotations];
        [after removeObject:[self userLocation]];
        NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
        [toKeep intersectSet:after];

        NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
        [toAdd minusSet:toKeep];

        NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
        [toRemove minusSet:after];

        [self.clusteredAnnotations unionSet:toAdd];
        [self.clusteredAnnotations minusSet:toRemove];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self removeAnnotations:[toRemove allObjects] completionBlock:^{
                [self.mapView addAnnotations:[toAdd allObjects]];
                NSTimeInterval interval = self.addAnnotationAnimationDuration + 0.25;  // animation + max possible stagger delay
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                                                                         //                        [self.lock unlock];
                                                                                                     });
            }];
        });

    });
    //    }
}

- (void)removeAnnotations:(NSArray *)annotations completionBlock:(VWWClusteredMapViewEmptyBlock)completionBlock {

    if (annotations.count == 0) {
        if (completionBlock) {
            completionBlock();
        }
        return;
    }
    if (self.addAnimationType == VWWClusteredMapViewAnnotationAddAnimationNone) {
        [self.mapView removeAnnotations:annotations];
        if (completionBlock) {
            completionBlock();
        }
    } else {
        __block NSUInteger count = 0;
        [annotations enumerateObjectsUsingBlock:^(id<MKAnnotation> annotation, NSUInteger idx, BOOL *stop) {
            MKAnnotationView *annotationView = [self.mapView viewForAnnotation:annotation];
            [UIView animateWithDuration:self.removeAnnotationAnimationDuration animations:^(void) {
                annotationView.transform = CGAffineTransformMakeScale(0.01, 0.01);
            }
                completion:^(BOOL finished) {
                    [self.mapView removeAnnotation:annotation];
                    annotationView.transform = CGAffineTransformIdentity;
                    count++;
                    if (count == annotations.count) {
                        if (completionBlock) {
                            completionBlock();
                        }
                    }
                }];
        }];
    }
}

- (NSSet *)annotationViewsOverlappingWithAnnotationView:(VWWClusteredAnnotationView *)view {

    id<MKAnnotation> annotation = view.annotation;
    // Get point from view.annotation
    MKMapPoint point = MKMapPointForCoordinate(annotation.coordinate);

    // Get size
    CGFloat widthRatio = view.bounds.size.width / self.mapView.bounds.size.width;  // 0..1
    CGFloat width = self.mapView.visibleMapRect.size.width * widthRatio;

    CGFloat heightRatio = view.bounds.size.height / self.mapView.bounds.size.height;  // 0..1
    CGFloat height = self.mapView.visibleMapRect.size.height * heightRatio;

    MKMapSize size = MKMapSizeMake(width, height);

    // Make rect
    const CGFloat kFactor = 1.5;
    width *= kFactor;
    height *= kFactor;
    MKMapRect rect = MKMapRectMake(point.x - width / 2.0, point.y - height / 2.0, size.width, size.height);

    //    // Check the rect by printing out human readable terms
    NSLog(@"\n");
    NSLog(@"width: %.1f height: %.1f", width, height);
    NSLog(@"view.class: %@", NSStringFromClass([view class]));

    // Get other annotations
    NSSet *overlappingAnnotations = [self.mapView annotationsInMapRect:rect];
    NSMutableSet *set = [[NSMutableSet alloc] initWithCapacity:overlappingAnnotations.count];
    // Fast enumeration on an NSMutableSet seems to be asynchronous
    for (id<MKAnnotation> annotation in overlappingAnnotations.allObjects) {
        id overlappingView = [self.mapView viewForAnnotation:annotation];

        // Print out human debug stuff
        NSLog(@"overlapping view.class: %@", NSStringFromClass([overlappingView class]));

        [set addObject:overlappingView];
    }
    return set;
}
@end
