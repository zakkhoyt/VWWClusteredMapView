//
//  HotelAnnotation.h
//  TBAnnotationClustering
//
//  Created by Zakk Hoyt on 9/25/14.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "HotelAnnotation.h"

@implementation HotelAnnotation

-(instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate name:(NSString*)name phoneNumber:(NSString*)phoneNumber{
    self = [super init];
    if(self){
        _coordinate = coordinate;
        _name = name;
        _phoneNumber = phoneNumber;
    }
    return self;
}

@end

@implementation HotelAnnotation (ReadFile)

+(NSArray*)readHotelsDataFile{
    @autoreleasepool {
        NSString *data = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"USA-HotelMotel" ofType:@"csv"] encoding:NSASCIIStringEncoding error:nil];
        if(data == nil){
            NSAssert(NO, @"Could not load CSV file which contains hotel information");
            return nil;
        }
        NSArray *lines = [data componentsSeparatedByString:@"\n"];
        NSInteger count = lines.count - 1;
        NSMutableArray *dataArray = [[NSMutableArray alloc]initWithCapacity:count];
//        for (NSInteger index = 0; index < 100; index++) {
        for (NSInteger index = 0; index < count; index++) {
            HotelAnnotation* data = [self dataFromLine:lines[index]];
            [dataArray addObject:data];
        }
        return dataArray;
    }
}

+(HotelAnnotation*)dataFromLine:(NSString*)line{
    NSArray *components = [line componentsSeparatedByString:@","];
    double latitude = [components[1] doubleValue];
    double longitude = [components[0] doubleValue];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    // Hotel with coordinate, name, phone
    NSString *hotelName = [components[2] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *hotelPhoneNumber = [[components lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    HotelAnnotation *hotelInfo = [[HotelAnnotation alloc]initWithCoordinate:coordinate name:hotelName phoneNumber:hotelPhoneNumber];
    
    return hotelInfo;
}

@end