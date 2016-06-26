//
//  VWWQuadTree.h
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.

#import <Foundation/Foundation.h>
#import "VWWQuadTreeNodeData.h"
#import "VWWBoundingBox.h"
#import "VWWQuadTreeNode.h"


@import MapKit;

typedef void(^VWWQuadTreeTraverseBlock)(VWWQuadTreeNode* currentNode);
typedef void(^VWWDataReturnBlock)(VWWQuadTreeNodeData* data);

@interface VWWQuadTree : NSObject
+(void)freeQuadTreeNode:(VWWQuadTreeNode*)node;
+(BOOL)boundingBox:(VWWBoundingBox*)box containsData:(VWWQuadTreeNodeData*)data;
+(BOOL)boundingBox:(VWWBoundingBox*)box1 intersectsBoundingBox:(VWWBoundingBox*)box2;
+(void)quadTreeTraverse:(VWWQuadTreeNode*)node block:(VWWQuadTreeTraverseBlock)block;
+(void)quadTree:(VWWQuadTreeNode*)node gatherDataInRange:(VWWBoundingBox*)range block:(VWWDataReturnBlock)block;
+(BOOL)quadTree:(VWWQuadTreeNode*)node insertData:(VWWQuadTreeNodeData*)data;
+(VWWQuadTreeNode*)quadTreeBuildWithData:(NSArray*)data boundingBox:(VWWBoundingBox*)boundingBox capacity:(NSInteger)capacity;

@end