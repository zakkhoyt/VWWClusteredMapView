//
//  ClusteredMapView+Private.m
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWClusteredMapView+Private.h"
#import "VWWClusteredMapView+ClassExtension.h"

@implementation VWWClusteredMapView (Private)

-(void)refreshClusterableAnnotations{
    if(self.annotationsAreClusterable) {
        double scale = self.bounds.size.width / self.visibleMapRect.size.width;
        NSArray *annotations = [self.coordinateQuadTree clusteredAnnotationsWithinMapRect:self.visibleMapRect withZoomScale:scale];
        [self updateMapViewAnnotationsWithAnnotations:annotations];
    }
}







- (void)updateMapViewAnnotationsWithAnnotations:(NSArray *)annotations {
    NSMutableSet *before = [NSMutableSet setWithArray:self.annotations];
    self.lastAnnotations = [NSSet setWithSet:before];
    [before removeObject:[self userLocation]];
    
    NSSet *after = [NSSet setWithArray:annotations];
    
    NSMutableSet *toKeep = [NSMutableSet setWithSet:before];
    [toKeep intersectSet:after];
    
    NSMutableSet *toAdd = [NSMutableSet setWithSet:after];
    [toAdd minusSet:toKeep];
    
    NSMutableSet *toRemove = [NSMutableSet setWithSet:before];
    [toRemove minusSet:after];
    
    
    [toAdd enumerateObjectsUsingBlock:^(VWWClusteredAnnotation *annotation, BOOL *stop) {
        // Find annotation in toKeep. Get point
        if([toKeep containsObject:annotation]){
            NSUInteger index = [toKeep.allObjects indexOfObject:annotation];
            VWWClusteredAnnotation *annotationToSplitFrom = toKeep.allObjects[index];
            CGPoint point = [self.mapView convertCoordinate:annotationToSplitFrom.coordinate toPointToView:self];
            annotation.splitFromPoint = point;
            NSLog(@"Updated splitFromPoint on annotation");
        }
    }];
    
    
    
    
    [self.mapView addAnnotations:[toAdd allObjects]];
    [self.mapView removeAnnotations:[toRemove allObjects]];
}

-(void)refreshAnnotations{
    [self.mapView removeAnnotations:self.annotations];
    if(self.annotationsAreClusterable){
        [self refreshClusterableAnnotations];
    } else {
        [self.mapView addAnnotations:self.unclusteredAnnotations];
    }
    
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
