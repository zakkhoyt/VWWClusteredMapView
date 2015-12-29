//
//  HotelAnnotationView..m
//  VWWClusteredMapViewExample
//
//  Created by Zakk Hoyt on 9/25/14.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "HotelAnnotationView.h"

static CGFloat const VWWScaleFactorAlpha = 0.3;
static CGFloat const VWWScaleFactorBeta = 0.4;

@interface HotelAnnotationView ()
@property (strong, nonatomic) UILabel *countLabel;
@end

@implementation HotelAnnotationView
- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setupLabel];
        [self setCount:1];
    }
    return self;
}

- (void)setupLabel{
    _countLabel = [[UILabel alloc] initWithFrame:self.frame];
    _countLabel.backgroundColor = [UIColor clearColor];
    _countLabel.textColor = [UIColor whiteColor];
    _countLabel.textAlignment = NSTextAlignmentCenter;
    _countLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.75];
    _countLabel.shadowOffset = CGSizeMake(0, -1);
    _countLabel.adjustsFontSizeToFitWidth = YES;
    _countLabel.numberOfLines = 1;
    _countLabel.font = [UIFont boldSystemFontOfSize:12];
    _countLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    [self addSubview:_countLabel];
}

- (void)setCount:(NSUInteger)count{
    _count = count;
    
    CGRect newBounds = CGRectMake(0, 0, roundf(44 * [self scaledValueForValue:count]), roundf(44 * [self scaledValueForValue:count]));
    self.frame = [self centerRect:newBounds onPoint:self.center];
    
    CGRect newLabelBounds = CGRectMake(0, 0, newBounds.size.width / 1.3, newBounds.size.height / 1.3);
    self.countLabel.frame = [self centerRect:newLabelBounds onPoint:[self centerOfRect:newBounds]];
    self.countLabel.text = [@(_count) stringValue];
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetAllowsAntialiasing(context, true);
    
    UIColor *outerCircleStrokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    UIColor *innerCircleStrokeColor = [UIColor orangeColor];
    UIColor *innerCircleFillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    
    CGRect circleFrame = CGRectInset(rect, 4, 4);
    
    [outerCircleStrokeColor setStroke];
    CGContextSetLineWidth(context, 5.0);
    CGContextStrokeEllipseInRect(context, circleFrame);
    
    [innerCircleStrokeColor setStroke];
    CGContextSetLineWidth(context, 4);
    CGContextStrokeEllipseInRect(context, circleFrame);
    
    [innerCircleFillColor setFill];
    CGContextFillEllipseInRect(context, circleFrame);
}


-(CGPoint)centerOfRect:(CGRect)rect{

    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

-(CGRect)centerRect:(CGRect)rect onPoint:(CGPoint)point{
    CGRect r = CGRectMake(point.x - rect.size.width/2.0,
                          point.y - rect.size.height/2.0,
                          rect.size.width,
                          rect.size.height);
    return r;
}


-(CGFloat)scaledValueForValue:(CGFloat)value{
    return 1.0 / (1.0 + expf(-1 * VWWScaleFactorAlpha * powf(value, VWWScaleFactorBeta)));
}


@end
