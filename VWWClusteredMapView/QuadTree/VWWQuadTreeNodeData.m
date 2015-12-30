//
//  VWWQuadTreeNodeData.m
//  Pods
//
//  Created by Zakk Hoyt on 12/29/15.
//
//

#import "VWWQuadTreeNodeData.h"

@interface VWWQuadTreeNodeData (){
    NSInteger _height;
}

@end
@implementation VWWQuadTreeNodeData

-(instancetype)initWithAnotation:(id<MKAnnotation>)annotation{
    self = [super init];
    if(self){
        _coordinate = annotation.coordinate;
        _data = annotation;
    }
    return self;
}
@end
