//
//  VWWClusterAnnotation.h
//  VWWAnnotationClustering
//
//  Created by Zakk Hoyt on 9/25/14.
//  Copyright (c) 2014 Theodore Calmes. All rights reserved.
//

#import <Foundation/Foundation.h>
@import  MapKit;

static NSString *const VWWAnnotatioViewReuseID = @"VWWAnnotatioViewReuseID";

@interface ClusteredAnnotation : NSObject <MKAnnotation>
- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate annotations:(NSArray*)annotations;

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (nonatomic, strong) NSArray *annotations;
@property (nonatomic) CGPoint initialPoint;
@property (nonatomic) CGPoint finalPoint;
@end
