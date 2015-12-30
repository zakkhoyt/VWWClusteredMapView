//
//  VWWBoundingBox.m
//  Pods
//
//  Created by Zakk Hoyt on 12/29/15.
//
//

#import "VWWBoundingBox.h"

@implementation VWWBoundingBox
-(instancetype)initWithX0:(CLLocationDegrees)x0 Y0:(CLLocationDegrees)y0 XF:(CLLocationDegrees)xf YF:(CLLocationDegrees)yf{
    self = [super init];
    if(self){
        _x0 = x0;
        _y0 = y0;
        _xf = xf;
        _yf = yf;
    }
    return self;
}
-(NSString*)description{
    return [NSString stringWithFormat:@"x0:%f xf:%f y0:%f yf:%f", _x0, _xf, _y0, _yf];
}

+(VWWBoundingBox*)boundingBoxForWorld{
    return [[VWWBoundingBox alloc]initWithX0:-90 Y0:-180 XF:90 YF:180];
};

@end