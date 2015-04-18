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

@interface ViewController () <VWWClusteredMapViewDelegate, UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet VWWClusteredMapView *mapView;
@property (nonatomic, strong) UIPopoverPresentationController *popover;
@property (weak, nonatomic) IBOutlet UIView *settingsContainerView;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.settingsButton.layer.cornerRadius = self.settingsButton.frame.size.height / 2.0;
    self.settingsButton.layer.borderWidth = 4;
    self.settingsButton.layer.borderColor = [UIColor greenColor].CGColor;
    self.settingsContainerView.alpha = 1.0;
    self.bottomConstraint.constant = -self.settingsContainerView.bounds.size.height;
    self.mapView.delegate = self;

    
    // Load hotels from CSV file
    NSArray *hotelAnnotations = [HotelAnnotation readHotelsDataFile];
    [self.mapView addAnnotations:hotelAnnotations];
}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.settingsButton];
    [self.view bringSubviewToFront:self.settingsContainerView];

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

#pragma mark Private Methods
-(void)panToAnnotationView:(MKAnnotationView*)view withPrettyFunction:(char*)function {
    id<MKAnnotation> annotation = view.annotation;
//    NSLog(@"%s %.4f,%.f", function, annotation.coordinate.latitude, annotation.coordinate.longitude);
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
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

@implementation ViewController (ClusteredMapViewDelegate)

#pragma mark Annotation Views
-(MKAnnotationView*)clusteredMapView:(VWWClusteredMapView *)clusteredMapView viewForAnnotation:(id<MKAnnotation>)annotation {
    HotelAnnotationView *annotationView = (HotelAnnotationView *)[clusteredMapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
    if (!annotationView) {
        annotationView = [[HotelAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
    }
    annotationView.canShowCallout = NO;
    annotationView.count = 1;
    return annotationView;
}

-(MKAnnotationView*)clusteredMapView:(VWWClusteredMapView *)clusteredMapView viewForClusteredAnnotation:(id<MKAnnotation>)annotation {
    HotelAnnotationView *annotationView = (HotelAnnotationView *)[clusteredMapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
    if (!annotationView) {
        annotationView = [[HotelAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ClusteredAnnotationView"];
    }
    annotationView.canShowCallout = YES;
    annotationView.count = ((VWWClusteredAnnotation*)annotation).annotations.count;
    return annotationView;
}


#pragma mark Annotation interaction


- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView didSelectAnnotationView:(MKAnnotationView *)view {
    [self panToAnnotationView:view withPrettyFunction:(char*)__PRETTY_FUNCTION__];
}

- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView didSelectClusteredAnnotationView:(VWWClusteredAnnotationView *)view {
    [self panToAnnotationView:view withPrettyFunction:(char*)__PRETTY_FUNCTION__];
}



@end
