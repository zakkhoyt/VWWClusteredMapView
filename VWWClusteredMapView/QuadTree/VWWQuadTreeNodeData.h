//
//  VWWQuadTreeNodeData.h
//  Pods
//
//  Created by Zakk Hoyt on 12/29/15.
//
//

#import <Foundation/Foundation.h>
@import MapKit;

@interface VWWQuadTreeNodeData : NSObject
-(instancetype)initWithAnotation:(id<MKAnnotation>) annotation;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSObject *data;
@end
