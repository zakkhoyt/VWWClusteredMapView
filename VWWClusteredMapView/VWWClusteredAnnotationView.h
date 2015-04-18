//
//  VWWClusteredAnnotationView.h
//  VWWClusteredMapViewExample
//
//  Created by Zakk Hoyt on 4/17/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import <MapKit/MapKit.h>



@interface VWWClusteredAnnotationView : MKAnnotationView

// These properties are not meant to be set by the end user.
@property (nonatomic) BOOL animateReclusting;
@property (nonatomic) CGPoint splitFromPoint; // initial position
@property (nonatomic) CGPoint point;
@property (nonatomic) CGPoint mergeToPoint; // final position

@end
