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

typedef void(^VWWClusteredMapViewEmptyBlock)(void);

@implementation VWWClusteredMapView (Private)

-(void)refreshClusterableAnnotations{
    // A quick way to see if the class's dataSource and delegate have been setup
    if(self.quadTrees == nil) return;
    
    double scale = self.bounds.size.width / self.visibleMapRect.size.width;
    
    NSMutableSet *toAddFromAllSections = [[NSMutableSet alloc]init];
    NSMutableSet *toRemoveFromAllSections = [[NSMutableSet alloc]init];
    
    NSUInteger sectionCount = [self.dataSource numberOfSectionsInMapView:self];
    
    for(NSUInteger sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++){
        VWWCoordinateQuadTree *quadTree = self.quadTrees[sectionIndex];
        NSArray *clusteredAnnotations = [quadTree clusteredAnnotationsWithinMapRect:self.visibleMapRect withZoomScale:scale];
        NSMutableSet *before = self.clusteredAnnotations[sectionIndex];
        [before removeObject:[self userLocation]];
        NSSet *after = [NSSet setWithArray:clusteredAnnotations];
        NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
        [toKeep intersectSet:after];
        NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
        [toAdd minusSet:toKeep];
        NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
        [toRemove minusSet:after];
        
        
        NSMutableArray *nextCA = [[self.clusteredAnnotations[sectionIndex] allObjects]mutableCopy];
        [nextCA addObjectsFromArray:[toAdd allObjects]];
        [nextCA removeObjectsInArray:[toRemove allObjects]];
        self.clusteredAnnotations[sectionIndex] = [NSMutableSet setWithArray:nextCA];
        [toAddFromAllSections unionSet:toAdd];
        [toRemoveFromAllSections unionSet:toRemove];
    }
    
//    NSLog(@"toRemoveFromAllSections.count: %lu", toRemoveFromAllSections.count);
//    NSLog(@"toAddFromAllSections.coutn: %lu", toAddFromAllSections.count);
    [self removeAnnotations:[toRemoveFromAllSections allObjects] completionBlock:^{
        [self.mapView addAnnotations:[toAddFromAllSections allObjects]];
    }];
    
//    NSLog(@"self.mapView.annotations.count: %lu", (unsigned long) self.mapView.annotations.count);
}

- (void)removeAnnotations:(NSArray*)annotations completionBlock:(VWWClusteredMapViewEmptyBlock)completionBlock{
    
    if(annotations.count == 0){
        return completionBlock();
    }
    if(self.animationType == VWWClusteredMapViewAnnotationAnimationNone){
        [self.mapView removeAnnotations:annotations];
        return completionBlock();
    }
    
    __block NSUInteger count = 0;
    [annotations enumerateObjectsUsingBlock:^(id<MKAnnotation> annotation, NSUInteger idx, BOOL *stop) {
        MKAnnotationView *annotationView = [self.mapView viewForAnnotation:annotation];
        [UIView animateWithDuration:self.removeAnnotationAnimationDuration animations:^(void){
            annotationView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        } completion:^(BOOL finished) {
            [self.mapView removeAnnotation:annotation];
            annotationView.transform = CGAffineTransformIdentity;
            count++;
            if(count == annotations.count){
                if(completionBlock){
                    completionBlock();
                }
            }
        }];
    }];
}

-(void)setAnimationPointsForAnnotationView:(VWWClusteredAnnotationView*)annotationView{
    
    //    VWWClusteredAnnotation *annotation = annotationView.annotation;
    //    if([annotation isKindOfClass:[VWWClusteredAnnotation class]] == NO){
    //        // TODO: Assert
    //        return;
    //    }
    //
    //    NSSet *annotationStacks = [NSSet setWithArray:annotation.annotations];
    //
    //
    //    // Find splits
    //    for(VWWClusteredAnnotation *lastAnnotation in self.lastClusteredAnnotations){
    //        NSSet *lastClusteredAnnotationstacks = [NSSet setWithArray:lastAnnotation.annotations];
    //        if([annotationStacks isSubsetOfSet:lastClusteredAnnotationstacks]){
    //            CGPoint fromPoint = [self.mapView convertCoordinate:lastAnnotation.coordinate toPointToView:self];
    //            annotationView.splitFromPoint = fromPoint;
    //            break;
    //        }
    //    }
    //
    //    // Find merges
    //    for(VWWClusteredAnnotation *lastAnnotation in self.lastClusteredAnnotations){
    //        NSSet *lastClusteredAnnotationstacks = [NSSet setWithArray:lastAnnotation.annotations];
    //        if([lastClusteredAnnotationstacks isSubsetOfSet:annotationStacks]){
    //            CGPoint toPoint = [self.mapView convertCoordinate:annotation.coordinate toPointToView:self];
    //            annotationView.mergeToPoint = toPoint;
    //            break;
    //        }
    //    }
    
}

//-(void)refreshAnnotations{
//    [self.mapView removeAnnotations:self.annotations];
//    [self refreshClusterableAnnotations];
//}




- (void)updateViewsBasedOnMapRegion:(CADisplayLink *)link{
    // Only re-render the layover if region has changed
    if(self.lastRegion.center.latitude != self.mapView.region.center.latitude ||
       self.lastRegion.center.longitude != self.mapView.region.center.longitude ||
       self.lastRegion.span.latitudeDelta != self.mapView.region.span.latitudeDelta  ||
       self.lastRegion.span.longitudeDelta != self.mapView.region.span.longitudeDelta){
        @synchronized(self){
            self.lastRegion = self.mapView.region;
        }
    }
}

@end
