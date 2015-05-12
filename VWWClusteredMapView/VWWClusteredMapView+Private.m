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

-(void)refreshClusterableAnnotations{

    NSMutableSet *toAddFromAllSections = [[NSMutableSet alloc]init];
    NSMutableSet *toRemoveFromAllSections = [[NSMutableSet alloc]init];
    
    NSUInteger sectionCount = [self.dataSource numberOfSectionsInMapView:self];
    for(NSUInteger sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++){
        double scale = self.bounds.size.width / self.visibleMapRect.size.width;
        VWWCoordinateQuadTree *quadTree = self.quadTrees[sectionIndex];
        NSArray *clusteredAnnotations = [quadTree clusteredAnnotationsWithinMapRect:self.visibleMapRect withZoomScale:scale];
        NSLog(@"%ld clustered annotations for section(%lu)", (long)clusteredAnnotations.count, (unsigned long)sectionIndex);

        NSArray *annotations = clusteredAnnotations;
        NSMutableSet *before = [NSMutableSet setWithArray:annotations];
        self.lastAnnotations[sectionIndex] = [NSSet setWithSet:before];
        [before removeObject:[self userLocation]];
        NSSet *after = [NSSet setWithArray:annotations];
        NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
        [toKeep intersectSet:after];
        NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
        [toAdd minusSet:toKeep];
        NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
        [toRemove minusSet:after];
        
        [toAddFromAllSections unionSet:toAdd];
        [toRemoveFromAllSections unionSet:toRemove];
        
        
        
        NSUInteger leafs = [quadTree leafCount];
        NSLog(@"%lu leafs", leafs);
    }
    
    [self.mapView addAnnotations:[toAddFromAllSections allObjects]];
    [self.mapView removeAnnotations:[toRemoveFromAllSections allObjects]];

}

//- (void)updateMapViewAnnotationsWithAnnotations:(NSArray *)annotations section:(NSUInteger)section{
//    NSMutableSet *before = [NSMutableSet setWithArray:self.annotations];
//    
//    self.lastAnnotations[section] = [NSSet setWithSet:before];
//    
//    [before removeObject:[self userLocation]];
//    
//    NSSet *after = [NSSet setWithArray:annotations];
//    
//    NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
//    [toKeep intersectSet:after];
//    
//    NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
//    [toAdd minusSet:toKeep];
//    
//    NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
//    [toRemove minusSet:after];
//    
//    [self.mapView addAnnotations:[toAdd allObjects]];
//    [self.mapView removeAnnotations:[toRemove allObjects]];
//    
//}

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
//    for(VWWClusteredAnnotation *lastAnnotation in self.lastAnnotations){
//        NSSet *lastAnnotationStacks = [NSSet setWithArray:lastAnnotation.annotations];
//        if([annotationStacks isSubsetOfSet:lastAnnotationStacks]){
//            CGPoint fromPoint = [self.mapView convertCoordinate:lastAnnotation.coordinate toPointToView:self];
//            annotationView.splitFromPoint = fromPoint;
//            break;
//        }
//    }
//    
//    // Find merges
//    for(VWWClusteredAnnotation *lastAnnotation in self.lastAnnotations){
//        NSSet *lastAnnotationStacks = [NSSet setWithArray:lastAnnotation.annotations];
//        if([lastAnnotationStacks isSubsetOfSet:annotationStacks]){
//            CGPoint toPoint = [self.mapView convertCoordinate:annotation.coordinate toPointToView:self];
//            annotationView.mergeToPoint = toPoint;
//            break;
//        }
//    }

}

-(void)refreshAnnotations{
    [self.mapView removeAnnotations:self.annotations];
    [self refreshClusterableAnnotations];
}




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
