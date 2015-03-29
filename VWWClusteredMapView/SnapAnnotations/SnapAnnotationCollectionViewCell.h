//
//  RDDistantAnnotationCollectionViewCell.h
//  Radius
//
//  Created by Zakk Hoyt on 3/24/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

static NSString *SnapAnnotationCollectionViewCellKey = @"SnapAnnotationCollectionViewCell";
@interface SnapAnnotationCollectionViewCell : UICollectionViewCell
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) MKAnnotationView *annotationView;
@end
