//
//  ViewController.m
//  ClusteredMap_demo
//
//  Created by Zakk Hoyt on 3/27/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "ViewController.h"
#import "SettingsTableViewController.h"

#import "HotelAnnotation.h"
#import "HotelAnnotationView.h"

#import "ClusteredMapView.h"

@interface ViewController () <ClusteredMapViewDelegate, UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet ClusteredMapView *mapView;
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
    self.bottomConstraint.constant = -206;
    self.mapView.delegate = self;
    self.mapView.snapInset = UIEdgeInsetsMake(22, 22, 22, 22);
    
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
            self.bottomConstraint.constant = -206;
            [UIView animateWithDuration:0.3 animations:^{
                [self.view layoutIfNeeded];
                self.settingsButton.alpha = 1.0;
            }];
        }];
    }
}


#pragma mark Private methods


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
-(MKAnnotationView*)clusteredMapView:(ClusteredMapView *)clusteredMapView viewForAnnotation:(id<MKAnnotation>)annotation {
    HotelAnnotationView *annotationView = (HotelAnnotationView *)[clusteredMapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
    if (!annotationView) {
        annotationView = [[HotelAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
    }
    annotationView.canShowCallout = NO;
    annotationView.count = 1;
    return annotationView;
}

-(MKAnnotationView*)clusteredMapView:(ClusteredMapView *)clusteredMapView viewForClusteredAnnotation:(id<MKAnnotation>)annotation {
    HotelAnnotationView *annotationView = (HotelAnnotationView *)[clusteredMapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
    if (!annotationView) {
        annotationView = [[HotelAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ClusteredAnnotationView"];
    }
    annotationView.canShowCallout = YES;
    annotationView.count = ((ClusteredAnnotation*)annotation).annotations.count;
    return annotationView;
}

// If this delegate method is not implemented, the default arrow image will be used (similar to how the map uses pins)
-(MKAnnotationView*)clusteredMapView:(ClusteredMapView *)clusteredMapView viewForSnappedAnnotation:(id<MKAnnotation>)annotation {
//    MKAnnotationView *av = [[MKAnnotationView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
//    av.backgroundColor = [UIColor yellowColor];
//    return av;
    return nil;
}

#pragma mark Annotation interaction

- (void)clusteredMapView:(ClusteredMapView *)clusteredMapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    id<MKAnnotation> annotation = view.annotation;
    NSLog(@"%.4f,%.f", annotation.coordinate.latitude, annotation.coordinate.longitude);
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
}

- (void)clusteredMapView:(ClusteredMapView *)clusteredMapView didSelectClusteredAnnotationView:(MKAnnotationView *)view {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    id<MKAnnotation> annotation = view.annotation;
    NSLog(@"%.4f,%.f", annotation.coordinate.latitude, annotation.coordinate.longitude);
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
}

- (void)clusteredMapView:(ClusteredMapView *)clusteredMapView didSelectSnapedAnnotationView:(MKAnnotationView *)view {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    id<MKAnnotation> annotation = view.annotation;
    NSLog(@"%.4f,%.f", annotation.coordinate.latitude, annotation.coordinate.longitude);
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
}


@end
