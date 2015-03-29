//
//  ClusteredMapView+SnapAnnotationsCollectionViewLayoutDelegate.m
//  ClusteredMap_demo
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//



#import "ClusteredMapView+SnapAnnotationsCollectionViewLayoutDelegate.h"
#import "ClusteredMapView+ClassExtension.h"
#import "SnapAnnotationsCollectionViewLayout.h"

@implementation ClusteredMapView (SnapAnnotationsCollectionViewLayoutDelegate)

-(CGSize)mapCollectionViewLayout:(SnapAnnotationsCollectionViewLayout*)sender sizeForIndexPath:(NSIndexPath*)indexPath{
    return CGSizeMake(44, 44);
}

-(CLLocationCoordinate2D)mapCollectionViewLayout:(SnapAnnotationsCollectionViewLayout*)sender coordinateForIndexPath:(NSIndexPath*)indexPath{
    id<MKAnnotation> annotation = nil;
    if(self.annotationsAreClusterable) {
        annotation = self.clusteredAnnotations[indexPath.item];
    } else {
        annotation = self.unclusteredAnnotations[indexPath.item];
    }
    return annotation.coordinate;
}

-(MKMapView*)mapCollectionViewLayoutMapView:(SnapAnnotationsCollectionViewLayout*)sender{
    return self.mapView;
}
-(UIEdgeInsets)mapCollectionViewContentInset:(SnapAnnotationsCollectionViewLayout*)sender{
    return self.snapInset;
}

-(CGRect)mapCollectionViewRectForVisibleCells:(SnapAnnotationsCollectionViewLayout*)sender{
    return self.mapView.frame;
}
-(BOOL)mapCollectionViewLayout:(SnapAnnotationsCollectionViewLayout*)sender keepIndexPathOnMap:(NSIndexPath*)indexPath{
    return YES;
}
@end
