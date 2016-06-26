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
    self.mapView.delegate = self;
    self.mapView.dataSource = self;

    // Load hotels from CSV file. Array of id<MKAnnotation> objects
    self.hotelAnnotations = [HotelAnnotation annotationsFromFile];
    [self.mapView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSLog(@"TODO: show details");
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Tapped" message:@"Annotation cluster tapped. Do what you will." preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
    [self presentViewController:ac animated:YES completion:NULL];
}

@end
