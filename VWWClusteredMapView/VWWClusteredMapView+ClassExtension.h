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
@property (nonatomic, strong) NSMutableArray *clusteredAnnotations;
@property (nonatomic, strong) NSMutableArray *unclusteredAnnotations;
@property (nonatomic, strong) VWWCoordinateQuadTree *coordinateQuadTree;
@property (nonatomic, strong) NSSet *lastAnnotations;

@property (nonatomic) MKCoordinateRegion lastRegion;

@end
