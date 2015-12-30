//
//  VWWBoundingBox.h
//  Pods
//
//  Created by Zakk Hoyt on 12/29/15.
//
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface VWWBoundingBox : NSObject
@property (nonatomic) CLLocationDegrees x0;
@property (nonatomic) CLLocationDegrees y0;
@property (nonatomic) CLLocationDegrees xf;
@property (nonatomic) CLLocationDegrees yf;
-(instancetype)initWithX0:(CLLocationDegrees)x0 Y0:(CLLocationDegrees)y0 XF:(CLLocationDegrees)xf YF:(CLLocationDegrees)yf;
+(VWWBoundingBox*)boundingBoxForWorld;
@end
