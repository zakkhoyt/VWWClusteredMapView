//
//  ClusteredMapView+SnapAnnotationsCollectionViewLayoutDelegate.m
//  ClusteredMap_demo
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//



#import "VWWClusteredMapView+SnapAnnotationsCollectionViewLayoutDelegate.h"
#import "VWWClusteredMapView+ClassExtension.h"
#import "VWWSnapAnnotationsCollectionViewLayout.h"

@implementation VWWClusteredMapView (SnapAnnotationsCollectionViewLayoutDelegate)

-(CGSize)mapCollectionViewLayout:(VWWSnapAnnotationsCollectionViewLayout*)sender sizeForIndexPath:(NSIndexPath*)indexPath{
    return CGSizeMake(44, 44);
}

-(CLLocationCoordinate2D)mapCollectionViewLayout:(VWWSnapAnnotationsCollectionViewLayout*)sender coordinateForIndexPath:(NSIndexPath*)indexPath{
    id<MKAnnotation> annotation = nil;
    if(self.annotationsAreClusterable) {
        annotation = self.clusteredAnnotations[indexPath.item];
    } else {
        annotation = self.unclusteredAnnotations[indexPath.item];
    }
    return annotation.coordinate;
}

-(MKMapView*)mapCollectionViewLayoutMapView:(VWWSnapAnnotationsCollectionViewLayout*)sender{
    return self.mapView;
}
-(UIEdgeInsets)mapCollectionViewContentInset:(VWWSnapAnnotationsCollectionViewLayout*)sender{
    return self.snapInset;
}

-(CGRect)mapCollectionViewRectForVisibleCells:(VWWSnapAnnotationsCollectionViewLayout*)sender{
    return self.mapView.frame;
}
-(BOOL)mapCollectionViewLayout:(VWWSnapAnnotationsCollectionViewLayout*)sender keepIndexPathOnMap:(NSIndexPath*)indexPath{
    return YES;
}
@end
