//
//  VWWCoordinateQuadTree.m
//  TBAnnotationClustering
//
//  Created by Zakk Hoyt on 9/25/14.
//  Copyright (c) 2014 Theodore Calmes. All rights reserved.
//

#import "VWWCoordinateQuadTree.h"
#import "VWWClusteredAnnotation.h"

@import Photos; 

@implementation VWWCoordinateQuadTree{
    NSUInteger _clusterDensity;
}

#pragma mark Public methods
-(instancetype)init{
    self = [super init];
    if(self){
        self.clusterDensity = 1;
    }
    return self;
}

-(void)buildTreeWithItems:(NSArray*)data{
    VWWBoundingBox *world = [[VWWBoundingBox alloc]initWithX0:-90 Y0:-180 XF:90 YF:180];
    self.root = [VWWQuadTree quadTreeBuildWithData:data count:data.count boundingBox:world capacity:4];
}

- (NSArray *)clusteredAnnotationsWithinMapRect:(MKMapRect)rect withZoomScale:(double)zoomScale
{
    double cellSize = [self cellSizeForZoomScale:zoomScale];
    double scaleFactor = zoomScale / cellSize;
    
    NSInteger minX = floor(MKMapRectGetMinX(rect) * scaleFactor);
    NSInteger maxX = floor(MKMapRectGetMaxX(rect) * scaleFactor);
    NSInteger minY = floor(MKMapRectGetMinY(rect) * scaleFactor);
    NSInteger maxY = floor(MKMapRectGetMaxY(rect) * scaleFactor);
    
    NSMutableArray *clusteredAnnotations = [[NSMutableArray alloc] init];
    for (NSInteger x = minX; x <= maxX; x++) {
        for (NSInteger y = minY; y <= maxY; y++) {
            MKMapRect mapRect = MKMapRectMake(x / scaleFactor, y / scaleFactor, 1.0 / scaleFactor, 1.0 / scaleFactor);
            
            __block double totalX = 0;
            __block double totalY = 0;
            __block int count = 0;
            
            NSMutableArray *annotations = [[NSMutableArray alloc]init];
            VWWBoundingBox *boundingBox = [self boundingBoxForMapRect:mapRect];
            [VWWQuadTree quadTree:self.root gatherDataInRange:boundingBox block:^(VWWQuadTreeNodeData *data) {
                count++;
                totalX += data.coordinate.latitude;
                totalY += data.coordinate.longitude;
                
                NSObject* annotation = data.data;
                [annotations addObject:annotation];
            }];
            
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(0, 0);
            coordinate = CLLocationCoordinate2DMake(totalX / count, totalY / count);

            VWWClusteredAnnotation *annotation = [[VWWClusteredAnnotation alloc]initWithCoordinate:coordinate annotations:annotations];
            [clusteredAnnotations addObject:annotation];
        }
    }
    
    return [NSArray arrayWithArray:clusteredAnnotations];
}


//-(NSUInteger)density{
//    return _density - 1;
//}
//-(NSUInteger)density{
//    return 1;
//}

-(void)setClusterDensity:(NSUInteger)clusterDensity{
    _clusterDensity = clusterDensity + 1;
}

-(NSUInteger)clusterDensity{
    return _clusterDensity - 1;
}

#pragma mark Private methods


-(float)cellSizeForZoomScale:(MKZoomScale)zoomScale {
    NSInteger zoomLevel = [self zoomScaleToZoomLevel:zoomScale];
    
    switch (zoomLevel) {
        case 13:
        case 14:
        case 15:
            return 32 * _clusterDensity;
        case 16:
        case 17:
        case 18:
            return 16 * _clusterDensity;
        case 19:
            return 8 * _clusterDensity;
            
        default:
            return 44 * _clusterDensity;
    }
}

-(NSInteger)zoomScaleToZoomLevel:(MKZoomScale)scale {
    double totalTilesAtMaxZoom = MKMapSizeWorld.width / 256.0;
    NSInteger zoomLevelAtMaxZoom = log2(totalTilesAtMaxZoom);
    NSInteger zoomLevel = MAX(0, zoomLevelAtMaxZoom + floor(log2f(scale) + 0.5));
    return zoomLevel;
}

-(VWWBoundingBox*)boundingBoxForMapRect:(MKMapRect)mapRect {
    CLLocationCoordinate2D topLeft = MKCoordinateForMapPoint(mapRect.origin);
    CLLocationCoordinate2D botRight = MKCoordinateForMapPoint(MKMapPointMake(MKMapRectGetMaxX(mapRect), MKMapRectGetMaxY(mapRect)));
    
    CLLocationDegrees minLat = botRight.latitude;
    CLLocationDegrees maxLat = topLeft.latitude;
    
    CLLocationDegrees minLon = topLeft.longitude;
    CLLocationDegrees maxLon = botRight.longitude;
    return [[VWWBoundingBox alloc]initWithX0:minLat Y0:minLon XF:maxLat YF:maxLon];
    
}

@end
