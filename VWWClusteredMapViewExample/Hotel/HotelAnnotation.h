//
//  HotelAnnotation.h
//  VWWClusteredMapViewExample
//
//  Created by Zakk Hoyt on 9/25/14.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface HotelAnnotation : NSObject <MKAnnotation>

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate name:(NSString*)name phoneNumber:(NSString*)phoneNumber;
// MKAnnotation
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

// Hotel
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSString *phoneNumber;
@end


@interface HotelAnnotation (ReadFile)
// Read hotels from file

+(NSArray*)annotationsFromFile;
+(HotelAnnotation*)dataFromLine:(NSString*)line;
@end

