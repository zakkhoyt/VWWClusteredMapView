//
//  VWWQuadTree.h
//  TBAnnotationClustering
//
//  Created by Zakk Hoyt on 9/25/14.
//  Copyright (c) 2014 Theodore Calmes. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface QuadTreeNodeData : NSObject
-(instancetype)initWithAnotation:(id<MKAnnotation>) annotation;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSObject *data;
@end

@interface BoundingBox : NSObject
@property (nonatomic) CLLocationDegrees x0;
@property (nonatomic) CLLocationDegrees y0;
@property (nonatomic) CLLocationDegrees xf;
@property (nonatomic) CLLocationDegrees yf;
-(instancetype)initWithX0:(CLLocationDegrees)x0 Y0:(CLLocationDegrees)y0 XF:(CLLocationDegrees)xf YF:(CLLocationDegrees)yf;
@end

@interface QuadTreeNode : NSObject
@property (nonatomic, strong) QuadTreeNode *northWest;
@property (nonatomic, strong) QuadTreeNode *northEast;
@property (nonatomic, strong) QuadTreeNode *southWest;
@property (nonatomic, strong) QuadTreeNode *southEast;
@property (nonatomic, strong) BoundingBox *boundingBox;
@property (nonatomic) NSInteger bucketCapacity;
@property (nonatomic, strong) NSMutableArray *points; // Contains VWWQuadTreeNodeData*
@property (nonatomic) NSInteger count;
-(instancetype)initWithBoundingBox:(BoundingBox*)boundingBox capacity:(NSInteger)capacity;
@end

typedef void(^QuadTreeTraverseBlock)(QuadTreeNode* currentNode);
typedef void(^DataReturnBlock)(QuadTreeNodeData* data);

@interface QuadTree : NSObject
+(void)freeQuadTreeNode:(QuadTreeNode*)node;
+(BOOL)boundingBox:(BoundingBox*)box containsData:(QuadTreeNodeData*)data;
+(BOOL)boundingBox:(BoundingBox*)box1 intersectsBoundingBox:(BoundingBox*)box2;
+(void)quadTreeTraverse:(QuadTreeNode*)node block:(QuadTreeTraverseBlock)block;
+(void)quadTree:(QuadTreeNode*)node gatherDataInRange:(BoundingBox*)range block:(DataReturnBlock)block;
+(BOOL)quadTree:(QuadTreeNode*)node insertData:(QuadTreeNodeData*)data;
+(QuadTreeNode*)quadTreeBuildWithData:(NSArray*)data count:(NSInteger)count boundingBox:(BoundingBox*)boundingBox capacity:(NSInteger)capacity;
@end