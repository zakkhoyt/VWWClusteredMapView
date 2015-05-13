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

typedef enum {
    ViewControllerSectionMotels = 0,
    ViewControllerSectionHotels = 1,
} ViewControllerSection;


@interface ViewController () <VWWClusteredMapViewDelegate, VWWClusteredMapViewDataSource, UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet VWWClusteredMapView *mapView;
@property (nonatomic, strong) NSArray *motelAnnotations;
@property (nonatomic, strong) NSArray *hotelAnnotations;

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
    self.settingsButton.layer.borderColor = [UIColor orangeColor].CGColor;
    self.settingsContainerView.alpha = 1.0;
    self.bottomConstraint.constant = -self.settingsContainerView.bounds.size.height;
    self.mapView.delegate = self;
    self.mapView.dataSource = self;

    
    // Load hotels from CSV file
    NSArray *allAnnotations = [HotelAnnotation readHotelsDataFile];
    NSIndexSet *motelIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 10)];
    self.motelAnnotations = [allAnnotations objectsAtIndexes:motelIndexSet];
    NSIndexSet *hotelIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(100, 10)];
    self.hotelAnnotations = [allAnnotations objectsAtIndexes:hotelIndexSet];
    
    [self.mapView reloadData];
    
//    [self.mapView addAnnotations:hotelAnnotations];
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



#pragma mark VWWClusteredMapViewDelegate
- (NSInteger)numberOfSectionsInMapView:(VWWClusteredMapView*)mapView{
    return 2;
}
- (NSInteger)mapView:(VWWClusteredMapView*)mapView numberOfAnnotationsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return self.motelAnnotations.count;
            break;
        case 1:
            return self.hotelAnnotations.count;
            break;
        default:
            return 0;
            break;
    }
}

- (id<MKAnnotation>)mapView:(VWWClusteredMapView*)mapView annotationForItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return self.motelAnnotations[indexPath.item];
            break;
        case 1:
            return self.hotelAnnotations[indexPath.item];
            break;
        default:
            return nil;
            break;
    }
}



#pragma mark VWWClusteredMapViewDelegate (Annotation Views)
-(MKAnnotationView *)clusteredMapView:(VWWClusteredMapView *)clusteredMapView viewForAnnotation:(id<MKAnnotation>)annotation {
    HotelAnnotationView *annotationView = (HotelAnnotationView *)[clusteredMapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
    if (!annotationView) {
        annotationView = [[HotelAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
    }
    annotationView.canShowCallout = NO;
    annotationView.count = 1;
    return annotationView;
}

-(VWWClusteredAnnotationView *)clusteredMapView:(VWWClusteredMapView *)clusteredMapView viewForClusteredAnnotation:(id<MKAnnotation>)annotation {
    HotelAnnotationView *annotationView = (HotelAnnotationView *)[clusteredMapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
    if (!annotationView) {
        annotationView = [[HotelAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ClusteredAnnotationView"];
    }
    annotationView.canShowCallout = YES;
    annotationView.count = ((VWWClusteredAnnotation*)annotation).annotations.count;

    
    
    // Set color depending on source
    VWWClusteredAnnotation *clusteredAnnotations = (VWWClusteredAnnotation *)annotation;
    HotelAnnotation *firstAnnotation = [clusteredAnnotations.annotations firstObject];
    if([self.motelAnnotations containsObject:firstAnnotation]){
        annotationView.annotationColor = [UIColor blueColor];
    } else if([self.hotelAnnotations containsObject:firstAnnotation]) {
        annotationView.annotationColor = [UIColor yellowColor];
    }
    
    return annotationView;
}


#pragma mark Annotation interaction

- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView didSelectClusteredAnnotationView:(VWWClusteredAnnotationView *)view {
    if([view isKindOfClass:[HotelAnnotationView class]]){
        VWWClusteredAnnotation *clusteredAnnotations = (VWWClusteredAnnotation*)view.annotation;
        NSLog(@"Printing annotation source **************************************************");
        [clusteredAnnotations.annotations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if([self.motelAnnotations containsObject:obj]){
                NSLog(@"Annotation %lu is in self.motels", (unsigned long)idx);
            } else if([self.hotelAnnotations containsObject:obj]) {
                NSLog(@"Annotation %lu is in self.hotels", (unsigned long)idx);
            }
        }];
    }
}



@end
