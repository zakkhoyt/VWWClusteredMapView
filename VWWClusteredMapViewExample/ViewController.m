//
//  ViewController.m
//  VWWClusteredMapViewExample
//
//  Created by Zakk Hoyt on 3/27/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "ViewController.h"
#import "SettingsTableViewController.h"

#import "HotelAnnotation.h"
#import "HotelAnnotationView.h"

#import "VWWClusteredMapView.h"

@interface ViewController ()

// Clustered map view UI
@property (weak, nonatomic) IBOutlet VWWClusteredMapView *mapView;

// Settings UI
@property (weak, nonatomic) IBOutlet UIView *settingsContainerView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

// Data source
@property (nonatomic, strong) NSArray *hotelAnnotations;

@end

@interface ViewController (VWWClusteredMapViewDataSource) <VWWClusteredMapViewDataSource>
@end

@interface ViewController (VWWClusteredMapViewDelegate) <VWWClusteredMapViewDelegate>
@end


@implementation ViewController

#pragma mark UIViewController methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setup our settings UI stuff
    self.settingsButton.layer.cornerRadius = self.settingsButton.frame.size.height / 2.0;
    self.settingsButton.layer.borderWidth = 4;
    self.settingsButton.layer.borderColor = [UIColor orangeColor].CGColor;
    self.settingsContainerView.alpha = 1.0;
    self.bottomConstraint.constant = -self.settingsContainerView.bounds.size.height;
    
    // Configure mapview data source and delegate
    self.mapView.delegate = self;
    self.mapView.dataSource = self;

    // Load hotels from CSV file
    self.hotelAnnotations = [HotelAnnotation annotationsFromFile];
    [self.mapView reloadData];
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"SegueMainToSettings"]) {
        SettingsTableViewController *vc = segue.destinationViewController;
        vc.mapView = self.mapView;
        [vc setHideButtonActionBlock:^{
            self.bottomConstraint.constant = -226;
            [UIView animateWithDuration:0.3 animations:^{
                [self.view layoutIfNeeded];
                self.settingsButton.alpha = 1.0;
            }];
        }];
    }
}

#pragma mark IBActions

- (IBAction)settingsButtonTouchUpInside:(id)sender {
    self.bottomConstraint.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
        self.settingsButton.alpha = 0.0;
    }];
}

@end

@implementation ViewController (VWWClusteredMapViewDataSource)

- (NSInteger)numberOfSectionsInMapView:(VWWClusteredMapView*)mapView{
    return 1;
}
- (NSInteger)mapView:(VWWClusteredMapView*)mapView numberOfAnnotationsInSection:(NSInteger)section{
    return self.hotelAnnotations.count;
}

- (id<MKAnnotation>)mapView:(VWWClusteredMapView*)mapView annotationForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.hotelAnnotations[indexPath.item];
}

@end

@implementation ViewController (VWWClusteredMapViewDelegate)

-(VWWClusteredAnnotationView *)clusteredMapView:(VWWClusteredMapView *)clusteredMapView viewForClusteredAnnotation:(VWWClusteredAnnotation*)annotation {
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }

    id obj = [annotation.annotations firstObject];
    if([obj isKindOfClass:[HotelAnnotation class]]){
        
        HotelAnnotationView *annotationView = (HotelAnnotationView *)[clusteredMapView dequeueReusableAnnotationViewWithIdentifier:@"HotelAnnotationView"];
        if (!annotationView) {
            annotationView = [[HotelAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"HotelAnnotationView"];
        }
        annotationView.canShowCallout = NO;
        annotationView.count = ((VWWClusteredAnnotation*)annotation).annotations.count;
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

