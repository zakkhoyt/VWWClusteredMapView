//
//  ClusteredMapView+Private.m
//  ClusteredMap_demo
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "ClusteredMapView+Private.h"
#import "ClusteredMapView+ClassExtension.h"

@implementation ClusteredMapView (Private)

-(void)refreshClusterableAnnotations{
    if(self.annotationsAreClusterable) {
        double scale = self.bounds.size.width / self.visibleMapRect.size.width;
        NSArray *annotations = [self.coordinateQuadTree clusteredAnnotationsWithinMapRect:self.visibleMapRect withZoomScale:scale];
        [self updateMapViewAnnotationsWithAnnotations:annotations];
    }
    [self refreshSnapableAnnotations];
}

-(void)refreshSnapableAnnotations {
    
    // If clustering is on we need to recalculate
    if(self.annotationsAreClusterable) {
        double scale = self.bounds.size.width / self.visibleMapRect.size.width;
        NSArray *annotations = [self.coordinateQuadTree clusteredAnnotationsWithinMapRect:self.visibleMapRect withZoomScale:scale];
        [self updateMapViewAnnotationsWithAnnotations:annotations];
        
        
        NSArray *clusters = [self.coordinateQuadTree clusteredAnnotationsWithinMapRect:MKMapRectWorld withZoomScale:scale];
        if(!self.clusteredAnnotations){
            self.clusteredAnnotations = [@[]mutableCopy];
        } else {
            [self.clusteredAnnotations removeAllObjects];
        }
        for(NSUInteger index = 0; index < clusters.count; index++){
            ClusteredAnnotation *cluster = clusters[index];
            if(cluster.annotations.count) {
                [self.clusteredAnnotations addObject:cluster];
            }
        }
    
    }
    
    [self.collectionView reloadData];
    
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
    
    [self.mapView addAnnotations:[toAdd allObjects]];
    [self.mapView removeAnnotations:[toRemove allObjects]];
}

-(void)refreshAnnotations{
    [self.mapView removeAnnotations:self.annotations];
    if(self.annotationsAreClusterable){
        [self refreshClusterableAnnotations];
    } else {
        [self.mapView addAnnotations:self.unclusteredAnnotations];
        [self refreshSnapableAnnotations];
    }
    
}




- (void)updateViewsBasedOnMapRegion:(CADisplayLink *)link{
    // Only re-render the layover if region has changed
    if(self.lastRegion.center.latitude != self.mapView.region.center.latitude ||
       self.lastRegion.center.longitude != self.mapView.region.center.longitude ||
       self.lastRegion.span.latitudeDelta != self.mapView.region.span.latitudeDelta  ||
       self.lastRegion.span.longitudeDelta != self.mapView.region.span.longitudeDelta){
        @synchronized(self){
            [self.collectionView.collectionViewLayout invalidateLayout];
            self.lastRegion = self.mapView.region;
        }
    }
}
@end
