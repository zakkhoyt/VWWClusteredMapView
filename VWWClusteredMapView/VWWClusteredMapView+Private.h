//
//  ClusteredMapView+Private.h
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWClusteredMapView.h"
#import "VWWClusteredAnnotationView.h"

@interface VWWClusteredMapView (Private)
-(void)refreshClusterableAnnotations;
-(void)updateViewsBasedOnMapRegion:(CADisplayLink *)link;
-(void)setAnimationPointsForAnnotationView:(VWWClusteredAnnotationView*)annotationView;
@end
