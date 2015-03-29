//
//  RDDistantAnnotationsCollectionViewLayout.h
//  Radius
//
//  Created by Zakk Hoyt on 3/24/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>


@class SnapAnnotationsCollectionViewLayout;

typedef void (^SnapBoolPointTransformBlock)(BOOL success, CGPoint point, CGAffineTransform transform);

@protocol SnapAnnotationsCollectionViewLayoutDelegate <NSObject>
-(CGSize)mapCollectionViewLayout:(SnapAnnotationsCollectionViewLayout*)sender sizeForIndexPath:(NSIndexPath*)indexPath;
-(CLLocationCoordinate2D)mapCollectionViewLayout:(SnapAnnotationsCollectionViewLayout*)sender coordinateForIndexPath:(NSIndexPath*)indexPath;
-(MKMapView*)mapCollectionViewLayoutMapView:(SnapAnnotationsCollectionViewLayout*)sender;
-(UIEdgeInsets)mapCollectionViewContentInset:(SnapAnnotationsCollectionViewLayout*)sender;
-(CGRect)mapCollectionViewRectForVisibleCells:(SnapAnnotationsCollectionViewLayout*)sender;
-(BOOL)mapCollectionViewLayout:(SnapAnnotationsCollectionViewLayout*)sender keepIndexPathOnMap:(NSIndexPath*)indexPath;
@end




@interface SnapAnnotationsCollectionViewLayout : UICollectionViewLayout
@property (nonatomic, weak) id <SnapAnnotationsCollectionViewLayoutDelegate> delegate;
//@property (nonatomic) BOOL keepAnnotationsOnMap;
//@property (nonatomic) BOOL busy;
//-(void)isPointWithinBounds:(CGPoint)point
//                 indexPath:(NSIndexPath*)indexPath
//           completionBlock:(SMBoolPointBlock)completionBlock;

@end
