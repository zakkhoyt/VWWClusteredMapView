//
//  ClusteredMapView+ClassExtension.h
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/27/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWClusteredMapView.h"
#import "VWWCoordinateQuadTree.h"


@interface VWWClusteredMapView () 
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSMutableSet *clusteredAnnotations;
@property (nonatomic, strong) NSSet *lastClusteredAnnotations;
@property (nonatomic, strong) VWWCoordinateQuadTree *quadTree;
@property (nonatomic, strong) NSLock *lock;

@end
