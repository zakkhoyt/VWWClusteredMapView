//
//  VWWQuadTreeNode.m
//  Pods
//
//  Created by Zakk Hoyt on 12/29/15.
//
//

#import "VWWQuadTreeNode.h"


@implementation VWWQuadTreeNode

-(instancetype)initWithBoundingBox:(VWWBoundingBox*)boundingBox capacity:(NSInteger)capacity{
    self = [super init];
    if(self){
        self.northWest = nil;
        self.northEast = nil;
        self.southWest = nil;
        self.southEast = nil;
        self.boundingBox = boundingBox;
        self.bucketCapacity = capacity;
        self.count = 0;
        self.points = [[NSMutableArray alloc]initWithCapacity:capacity];
    }
    return self;
}

-(NSString*)description{
    return [NSString stringWithFormat:@"\nnorthWest: %@"
            @"\nnorthEast: %@"
            @"\nsouthWest: %@"
            @"\nsouthEast: %@"
            @"\nboundingBox: %@"
            @"\nbucketCapacity: %ld"
            @"\ncount: %ld"
            @"\npoints.size: %ld",
            self.northWest.description,
            self.northEast.description,
            self.southWest.description,
            self.southEast.description,
            self.boundingBox.description,
            (long)self.bucketCapacity,
            (long)self.count,
            (long)self.points.count];
}


//-(NSUInteger)heightFromNode:(VWWQuadTreeNode*)node height:(NSUInteger)height{
//
//    // Base case
//
//
//    // Recursion
//    if(node.northWest){
//        [self heightFromNode:node.northWest height:height];
//    }
//    if(node.northEast){
//        [self heightFromNode:node.northWest height:height];
//    }
//    if(node.southWest){
//        [self heightFromNode:node.northWest height:height];
//    }
//    if(node.southEast){
//        [self heightFromNode:node.northWest height:height];
//    }
//    return 0;
//}


@end
