//
//  VWWCoordinateQuadTree.h
//  TBAnnotationClustering
//
//  Created by Zakk Hoyt on 9/25/14.
//  Copyright (c) 2014 Theodore Calmes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VWWQuadTree.h"





@interface VWWCoordinateQuadTree : NSObject

@property (nonatomic, strong) VWWQuadTreeNode *root;
@property (nonatomic, strong) MKMapView *mapView;

-(instancetype)init;
-(void)buildTreeWithItems:(NSArray*)data;
-(NSArray*)clusteredAnnotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale;
-(void)setClusterDensity:(NSUInteger)density;
-(NSUInteger)clusterDensity;
@end
