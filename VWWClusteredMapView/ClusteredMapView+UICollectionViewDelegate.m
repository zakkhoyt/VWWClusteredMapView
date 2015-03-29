//
//  ClusteredMapView+UICollectionViewDelegate.m
//  ClusteredMap_demo
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "ClusteredMapView+UICollectionViewDelegate.h"
#import "SnapAnnotationCollectionViewCell.h"

@implementation ClusteredMapView (UICollectionViewDelegate)
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SnapAnnotationCollectionViewCell *cell = (SnapAnnotationCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if(cell == nil) return;
    
    MKAnnotationView *annotationView = cell.annotationView;
    if(annotationView == nil) return;
    
    if([self.delegate respondsToSelector:@selector(clusteredMapView:didSelectSnapedAnnotationView:)]) {
        [self.delegate clusteredMapView:self didSelectSnapedAnnotationView:annotationView];
    }
}
@end
