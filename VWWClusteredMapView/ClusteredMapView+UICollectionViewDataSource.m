//
//  ClusteredMapView+UICollectionViewDataSource.m
//  ClusteredMap_demo
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "ClusteredMapView+UICollectionViewDataSource.h"
#import "SnapAnnotationCollectionViewCell.h"
#import "ClusteredMapView+ClassExtension.h"

@interface ClusteredMapView ()
@property (nonatomic, strong) MKAnnotationView *annotationView;
@end

@implementation ClusteredMapView (UICollectionViewDataSource)
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)cv {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)cv numberOfItemsInSection:(NSInteger)section {
    if(self.annotationsAreSnapable){
        if(self.annotationsAreClusterable) {
            return self.clusteredAnnotations.count;
        } else {
            return self.unclusteredAnnotations.count;
        }
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SnapAnnotationCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SnapAnnotationCollectionViewCellKey forIndexPath:indexPath];

    MKAnnotationView *annotationView = nil;
    id<MKAnnotation> annotation = nil;
    if([self.delegate respondsToSelector:@selector(clusteredMapView:viewForSnappedAnnotation:)]){
        if(self.annotationsAreClusterable) {
            annotation = self.clusteredAnnotations[indexPath.item];
        } else {
            annotation = self.unclusteredAnnotations[indexPath.item];
        }
        annotationView = [self.delegate clusteredMapView:self viewForSnappedAnnotation:annotation];
        annotationView.annotation = annotation;
    }
    
    // If delegate doesn't define an annotation view, use our default view
    annotationView = [[MKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"DefaultSnapPin"];
    annotationView.image = [UIImage imageNamed:@"SnapAnnotationImage"];
    annotationView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:0 alpha:0.1];
    annotationView.layer.cornerRadius = annotationView.frame.size.width / 2.0;
    annotationView.layer.borderColor = [UIColor redColor].CGColor;
    annotationView.layer.borderWidth = 1.0;
    
    if(annotationView) {
        cell.annotationView = annotationView;
    }

    return cell;
}

@end
