//
//  SettingsViewController.m
//  VWWClusteredMapViewExample
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()
@property (nonatomic, strong) SettingsTableViewControllerEmptyBlock hideButtonActionBlock;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mapTypeSegment;
@property (weak, nonatomic) IBOutlet UISwitch *annotationsAreClusterableSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *clusterDensitySegment;
@end



@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapTypeSegment.selectedSegmentIndex = 0;
    self.clusterDensitySegment.selectedSegmentIndex = (NSUInteger)self.mapView.clusterDensity;
}

#pragma mark Public methods
-(void)setHideButtonActionBlock:(SettingsTableViewControllerEmptyBlock)hideButtonActionBlock{
    _hideButtonActionBlock = hideButtonActionBlock;
}


#pragma mark IBActions
- (IBAction)mapTypeSegmentValueChanged:(UISegmentedControl*)sender {
    MKMapType mapType = (MKMapType)sender.selectedSegmentIndex;
    self.mapView.mapType = mapType;
}


- (IBAction)clusterDensitySegmentValueChanged:(UISegmentedControl*)sender {
    self.mapView.clusterDensity = (ClusterMapViewDensity)sender.selectedSegmentIndex;
}


- (IBAction)doneButtonTouchUpInside:(id)sender {
    if(_hideButtonActionBlock) {
        _hideButtonActionBlock();
    }
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}


@end
