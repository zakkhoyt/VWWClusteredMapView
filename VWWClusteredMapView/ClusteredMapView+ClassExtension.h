//
//  ClusteredMapView+ClassExtension.h
//  ClusteredMap_demo
//
//  Created by Zakk Hoyt on 3/27/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "ClusteredMapView.h"
#import "CoordinateQuadTree.h"
#import "SnapAnnotationsCollectionViewLayout.h"
#import "SnapAnnotationsCollectionView.h"


@interface ClusteredMapView () 
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSMutableArray *clusteredAnnotations;
@property (nonatomic, strong) NSMutableArray *unclusteredAnnotations;
@property (nonatomic, strong) CoordinateQuadTree *coordinateQuadTree;
@property (nonatomic, strong) NSSet *lastAnnotations;


@property (nonatomic, strong) SnapAnnotationsCollectionView *collectionView;
@property (nonatomic, strong) SnapAnnotationsCollectionViewLayout *layout;
@property (nonatomic) MKCoordinateRegion lastRegion;

@end
