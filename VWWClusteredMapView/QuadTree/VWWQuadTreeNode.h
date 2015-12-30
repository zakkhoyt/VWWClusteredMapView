//
//  VWWQuadTreeNode.h
//  Pods
//
//  Created by Zakk Hoyt on 12/29/15.
//
//

#import <Foundation/Foundation.h>
#import "VWWBoundingBox.h"
@import MapKit;

@interface VWWQuadTreeNode : NSObject
@property (nonatomic, strong) VWWQuadTreeNode *northWest;
@property (nonatomic, strong) VWWQuadTreeNode *northEast;
@property (nonatomic, strong) VWWQuadTreeNode *southWest;
@property (nonatomic, strong) VWWQuadTreeNode *southEast;
@property (nonatomic, strong) VWWBoundingBox *boundingBox;
// TODO MAP: no need for bucketCapacity in obj-c. This is a byproduct of the port from C code. Remove with caution.
@property (nonatomic) NSInteger bucketCapacity;
@property (nonatomic, strong) NSMutableArray *points; // Contains VWWQuadTreeNodeData*
@property (nonatomic) NSInteger count;
-(instancetype)initWithBoundingBox:(VWWBoundingBox*)boundingBox capacity:(NSInteger)capacity;
@end
