//
//  AnnotationView.h
//  TBAnnotationClustering
//
//  Created by Zakk Hoyt on 9/25/14.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "VWWClusteredAnnotationView.h"

@interface HotelAnnotationView : VWWClusteredAnnotationView

@property (assign, nonatomic) NSUInteger count;
@property (nonatomic, copy) UIColor *annotationColor;
@end
