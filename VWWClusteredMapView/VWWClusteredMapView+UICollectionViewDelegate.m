//
//  ClusteredMapView+UICollectionViewDelegate.m
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "VWWClusteredMapView+UICollectionViewDelegate.h"
#import "VWWSnapAnnotationCollectionViewCell.h"

@implementation VWWClusteredMapView (UICollectionViewDelegate)
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VWWSnapAnnotationCollectionViewCell *cell = (VWWSnapAnnotationCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if(cell == nil) return;
    
    MKAnnotationView *annotationView = cell.annotationView;
    if(annotationView == nil) return;
    
    if([self.delegate respondsToSelector:@selector(clusteredMapView:didSelectSnapedAnnotationView:)]) {
        [self.delegate clusteredMapView:self didSelectSnapedAnnotationView:annotationView];
    }
}
@end
