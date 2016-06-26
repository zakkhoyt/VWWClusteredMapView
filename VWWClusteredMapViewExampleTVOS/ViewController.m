//
//  ViewController.m
//  VWWClusteredMapViewExampleTVOS
//
//  Created by Zakk Hoyt on 6/25/16.
//  Copyright © 2016 Zakk Hoyt. All rights reserved.
//

#import "ViewController.h"
#import "VWWClusteredMapView.h"

#import "HotelAnnotation.h"
#import "HotelAnnotationView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet VWWClusteredMapView *mapView;

// Data source
@property (nonatomic, strong) NSArray *hotelAnnotations;

@end

@interface ViewController (VWWClusteredMapViewDataSource) <VWWClusteredMapViewDataSource>
@end

@interface ViewController (VWWClusteredMapViewDelegate) <VWWClusteredMapViewDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Configure mapview data source and delegate
    self.mapView.addAnimationType = VWWClusteredMapViewAnnotationAddAnimationNone;
    self.mapView.clusterDensity = ClusterMapViewDensityMacho;
    self.mapView.enableFanout = NO;
    self.mapView.delegate = self;
    self.mapView.dataSource = self;

    // Load hotels from CSV file. Array of id<MKAnnotation> objects
    self.hotelAnnotations = [HotelAnnotation annotationsFromFileWithLimit:@(1000)];
    [self.mapView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    NSLog(@"ViewController ");
    if ([context.previouslyFocusedView isKindOfClass:[HotelAnnotationView class]]) {
        HotelAnnotationView *view = (HotelAnnotationView *)context.previouslyFocusedView;
        view.transform = CGAffineTransformIdentity;
    }

    if ([context.nextFocusedView isKindOfClass:[HotelAnnotationView class]]) {
        HotelAnnotationView *view = (HotelAnnotationView *)context.nextFocusedView;
        view.transform = CGAffineTransformMakeScale(5.0, 5.0);
    }
}

@end

@implementation ViewController (VWWClusteredMapViewDataSource)
- (NSInteger)mapViewNumberOfAnnotations:(VWWClusteredMapView *)mapView {
    return self.hotelAnnotations.count;
}

- (id<MKAnnotation>)mapView:(VWWClusteredMapView *)mapView annotationForItemAtIndex:(NSInteger)index {
    return self.hotelAnnotations[index];
}

@end

@implementation ViewController (VWWClusteredMapViewDelegate)

- (VWWClusteredAnnotationView *)clusteredMapView:(VWWClusteredMapView *)clusteredMapView viewForClusteredAnnotation:(VWWClusteredAnnotation *)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }

    id obj = [annotation.annotations firstObject];
    if ([obj isKindOfClass:[HotelAnnotation class]]) {

        HotelAnnotationView *annotationView = (HotelAnnotationView *)[clusteredMapView dequeueReusableAnnotationViewWithIdentifier:@"HotelAnnotationView"];
        if (!annotationView) {
            annotationView = [[HotelAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"HotelAnnotationView"];
        }
        annotationView.canShowCallout = NO;
        annotationView.count = ((VWWClusteredAnnotation *)annotation).annotations.count;
        return annotationView;
    }

    return nil;
}

- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView didSelectClusteredAnnotationView:(VWWClusteredAnnotationView *)view {
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformMakeScale(2, 2);
        view.alpha = 0.5;
    }];

    //    NSLog(@"TODO: show details");
    //    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Tapped" message:@"Annotation cluster tapped. Do what you will." preferredStyle:UIAlertControllerStyleAlert];
    //    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
    //    [self presentViewController:ac animated:YES completion:NULL];
}

- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView didDeselectClusteredAnnotationView:(VWWClusteredAnnotationView *)view {
    view.transform = CGAffineTransformIdentity;
    view.alpha = 1.0;
}

@end
