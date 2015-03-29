//
//  VWWQuadTree.m
//  TBAnnotationClustering
//
//  Created by Zakk Hoyt on 9/25/14.
//  Copyright (c) 2014 Theodore Calmes. All rights reserved.
//

#import "QuadTree.h"



@implementation QuadTreeNodeData

-(instancetype)initWithAnotation:(id<MKAnnotation>)annotation{
    self = [super init];
    if(self){
        _coordinate = annotation.coordinate;
        _data = annotation;
    }
    return self;
}
@end


@implementation BoundingBox
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

@end


@implementation QuadTreeNode

-(instancetype)initWithBoundingBox:(BoundingBox*)boundingBox capacity:(NSInteger)capacity{
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

@end

@implementation QuadTree

#pragma mark Public methods

+(void)freeQuadTreeNode:(QuadTreeNode*)node{
    if(node.northWest != nil) [QuadTree freeQuadTreeNode:node.northWest];
    if(node.northEast != nil) [QuadTree freeQuadTreeNode:node.northEast];
    if(node.southWest != nil) [QuadTree freeQuadTreeNode:node.southWest];
    if(node.southEast != nil) [QuadTree freeQuadTreeNode:node.southEast];

    [node.points removeAllObjects];

    node = nil;
}

+(BOOL)boundingBox:(BoundingBox*)box containsData:(QuadTreeNodeData*)data{
    bool containsX = box.x0 <= data.coordinate.latitude && data.coordinate.latitude <= box.xf;
    bool containsY = box.y0 <= data.coordinate.longitude && data.coordinate.longitude <= box.yf;
    return containsX && containsY;
}

+(BOOL)boundingBox:(BoundingBox*)box1 intersectsBoundingBox:(BoundingBox*)box2{
    return (box1.x0 <= box2.xf &&
            box1.xf >= box2.x0 &&
            box1.y0 <= box2.yf &&
            box1.yf >= box2.y0);
}

+(void)quadTreeTraverse:(QuadTreeNode*)node block:(QuadTreeTraverseBlock)block{
    block(node);
    
    if(node.northWest == nil){
        return;
    }
    
    [QuadTree quadTreeTraverse:node.northWest block:block];
    [QuadTree quadTreeTraverse:node.northEast block:block];
    [QuadTree quadTreeTraverse:node.southWest block:block];
    [QuadTree quadTreeTraverse:node.southEast block:block];
}


+(void)quadTree:(QuadTreeNode*)node gatherDataInRange:(BoundingBox*)range block:(DataReturnBlock)block{
    if([QuadTree boundingBox:node.boundingBox intersectsBoundingBox:range] == NO){
        return;
    }
    
    for(NSUInteger index = 0; index < node.count; index++){
        if([QuadTree boundingBox:range containsData:node.points[index]]){
            block(node.points[index]);
        }
    }
    
    if(node.northWest == nil){
        return;
    }
    
    [QuadTree quadTree:node.northWest gatherDataInRange:range block:block];
    [QuadTree quadTree:node.northEast gatherDataInRange:range block:block];
    [QuadTree quadTree:node.southWest gatherDataInRange:range block:block];
    [QuadTree quadTree:node.southEast gatherDataInRange:range block:block];
}

+(BOOL)quadTree:(QuadTreeNode*)node insertData:(QuadTreeNodeData*)data{
    static NSUInteger callCounter = 0;
    callCounter++;

    if([QuadTree boundingBox:node.boundingBox containsData:data] == NO){
        return NO;
    }
    
    if(node.count < node.bucketCapacity){
        node.points[node.count++] = data;
        return YES;
    }
    
    if(node.northWest == nil){
        [QuadTree quadTreeNodeSubdivide:node];
    }
    
    if([QuadTree quadTree:node.northWest insertData:data]){
        return YES;
    }
    if([QuadTree quadTree:node.northEast insertData:data]){
        return YES;
    }
    if([QuadTree quadTree:node.southWest insertData:data]){
        return YES;
    }
    if([QuadTree quadTree:node.southEast insertData:data]){
        return YES;
    }
    
    return NO;
}

+(QuadTreeNode*)quadTreeBuildWithData:(NSArray*)data
                                   count:(NSInteger)count
                             boundingBox:(BoundingBox*)boundingBox
                                capacity:(NSInteger)capacity{
    QuadTreeNode *root = [[QuadTreeNode alloc]initWithBoundingBox:boundingBox capacity:capacity];
    for(NSUInteger index = 0; index < count; index++){
        [QuadTree quadTree:root insertData:data[index]];
    }
    return root;
}



#pragma mark Private methods
+(void)quadTreeNodeSubdivide:(QuadTreeNode*)node {
    BoundingBox *box = node.boundingBox;
    double latitudeMid = (box.xf + box.x0) / 2.0;
    double longitudeMid = (box.yf + box.y0) / 2.0;
    
    BoundingBox *northWest = [[BoundingBox alloc]initWithX0:box.x0 Y0:box.y0 XF:latitudeMid YF:longitudeMid];
    node.northWest = [[QuadTreeNode alloc]initWithBoundingBox:northWest capacity:node.bucketCapacity];

    BoundingBox *northEast = [[BoundingBox alloc]initWithX0:latitudeMid Y0:box.y0 XF:box.xf YF:longitudeMid];
    node.northEast = [[QuadTreeNode alloc]initWithBoundingBox:northEast capacity:node.bucketCapacity];

    BoundingBox *southWest = [[BoundingBox alloc]initWithX0:box.x0 Y0:longitudeMid XF:latitudeMid YF:box.yf];
    node.southWest = [[QuadTreeNode alloc]initWithBoundingBox:southWest capacity:node.bucketCapacity];

    BoundingBox *southEast = [[BoundingBox alloc]initWithX0:latitudeMid Y0:longitudeMid XF:box.xf YF:box.yf];
    node.southEast = [[QuadTreeNode alloc]initWithBoundingBox:southEast capacity:node.bucketCapacity];

}

@end
