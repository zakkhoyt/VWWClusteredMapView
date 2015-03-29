//
//  VWWClusterAnnotation.m
//  VWWAnnotationClustering
//
//  Created by Zakk Hoyt on 9/25/14.
//  Copyright (c) 2014 Theodore Calmes. All rights reserved.
//

#import "ClusteredAnnotation.h"

@implementation ClusteredAnnotation

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate annotations:(NSArray*)annotations {
    self = [super init];
    if (self) {
        _coordinate = coordinate;
        _title = [NSString stringWithFormat:@"%u hotels in this area", (int)annotations.count];
        _annotations = annotations;
    }
    return self;
}

-(NSUInteger)hash {
    NSString *toHash = [NSString stringWithFormat:@"%.5F%.5F", self.coordinate.latitude, self.coordinate.longitude];
    return [toHash hash];
}

-(BOOL)isEqual:(id)object {
    return [self hash] == [object hash];
}

@end
