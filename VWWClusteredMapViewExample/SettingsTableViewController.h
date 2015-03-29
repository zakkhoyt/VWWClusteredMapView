//
//  SettingsViewController.h
//  ClusteredMap_demo
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClusteredMapView.h"

typedef void(^SettingsTableViewControllerEmptyBlock)(void);

@interface SettingsTableViewController : UITableViewController
@property (nonatomic, strong) ClusteredMapView *mapView;
-(void)setHideButtonActionBlock:(SettingsTableViewControllerEmptyBlock)hideButtonActionBlock;
@end
