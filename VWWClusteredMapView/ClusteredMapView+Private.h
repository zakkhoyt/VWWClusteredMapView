//
//  ClusteredMapView+Private.h
//  ClusteredMap_demo
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "ClusteredMapView.h"

@interface ClusteredMapView (Private)
-(void)refreshClusterableAnnotations;
-(void)refreshAnnotations;
- (void)updateViewsBasedOnMapRegion:(CADisplayLink *)link;
@end
