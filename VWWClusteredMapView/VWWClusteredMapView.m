//
//  ClusteredMapView.m
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.

#import "VWWClusteredMapView.h"
#import "VWWClusteredMapView+ClassExtension.h"
#import "VWWClusteredMapView+Private.h"
#import "VWWClusteredMapView+MKMapViewDelegate.h"

#import "VWWQuadTree.h"

@implementation VWWClusteredMapView
- (id)init {
    return [self initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitWithFrame:frame];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        CGRect innerFrame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        [self commonInitWithFrame:innerFrame];
    }
    return self;
}

- (void)commonInitWithFrame:(CGRect)frame {
    self.lock = [NSLock new];
    self.addAnnotationAnimationDuration = 0.25;
    self.removeAnnotationAnimationDuration = 0.075;
    self.enableFanout = YES;

    self.addAnimationType = VWWClusteredMapViewAnnotationAddAnimationAutomatic;
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:frame];
    mapView.delegate = (id<MKMapViewDelegate>)self;
    mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mapView.showsUserLocation = NO;
    [self addSubview:mapView];
    [self setMapView:mapView];
    [self setAnimateReclusting:YES];
    [self setClusterDensity:ClusterMapViewDensityNormal];
}

- (ClusterMapViewDensity)clusterDensity {
    if (self.quadTree) {
        return (ClusterMapViewDensity)self.quadTree.clusterDensity;
    }

    return ClusterMapViewDensityNormal;
}

- (void)setClusterDensity:(ClusterMapViewDensity)clusterDensity {
    self.quadTree.clusterDensity = (NSUInteger)clusterDensity;
    [self refreshClusterableAnnotations];
}


- (void)reloadData {
    // Remove current annotations and clean up data
    [self.mapView removeAnnotations:self.mapView.annotations];
    _quadTree = nil;
    
    self.quadTree = [[VWWCoordinateQuadTree alloc] init];
    self.clusteredAnnotations = [[NSMutableSet alloc] init];
    self.lastClusteredAnnotations = [[NSMutableSet alloc] init];

    // Build clustered annotations from loose annotations
    NSMutableArray *annotations = [@[] mutableCopy];
    NSUInteger itemCount = [self.dataSource mapViewNumberOfAnnotations:self];
    for (NSUInteger itemIndex = 0; itemIndex < itemCount; itemIndex++) {
        id<MKAnnotation> annotation = [self.dataSource mapView:self annotationForItemAtIndex:itemIndex];
        [annotations addObject:annotation];
    }

    // Cluster annotations for section
    NSMutableArray *nodes = [@[] mutableCopy];
    [annotations enumerateObjectsUsingBlock:^(id<MKAnnotation> annotation, NSUInteger idx, BOOL *stop) {
        VWWQuadTreeNodeData *node = [[VWWQuadTreeNodeData alloc] initWithAnotation:annotation];
        [nodes addObject:node];
    }];
    [self.quadTree buildTreeWithItems:nodes];

    [self refreshClusterableAnnotations];
}

@end

@implementation VWWClusteredMapView (MKMapView)

#pragma mark MKMapView hijacks
- (MKMapType)mapType {
    return self.mapView.mapType;
}

- (void)setMapType:(MKMapType)mapType {
    [self.mapView setMapType:mapType];
}

- (MKCoordinateRegion)region {
    return self.mapView.region;
}
- (void)setRegion:(MKCoordinateRegion)region {
    [self.mapView setRegion:region];
}
- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)animated {
    [self.mapView setRegion:region animated:animated];
}

- (CLLocationCoordinate2D)centerCoordinate {
    return self.mapView.centerCoordinate;
}
- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate {
    [self.mapView setCenterCoordinate:coordinate];
}
- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated {
    [self.mapView setCenterCoordinate:coordinate animated:animated];
}

- (MKCoordinateRegion)regionThatFits:(MKCoordinateRegion)region {
    return [self.mapView regionThatFits:region];
}

- (MKMapRect)visibleMapRect {
    return self.mapView.visibleMapRect;
}
- (void)setVisibleMapRect:(MKMapRect)visibleMapRect {
    [self.mapView setVisibleMapRect:visibleMapRect];
}
- (void)setVisibleMapRect:(MKMapRect)mapRect animated:(BOOL)animate {
    [self.mapView setVisibleMapRect:mapRect animated:animate];
}

- (MKMapRect)mapRectThatFits:(MKMapRect)mapRect {
    return [self.mapView mapRectThatFits:mapRect];
}

#if TARGET_OS_IPHONE
- (void)setVisibleMapRect:(MKMapRect)mapRect edgePadding:(UIEdgeInsets)insets animated:(BOOL)animate {
    [self.mapView setVisibleMapRect:mapRect edgePadding:insets animated:animate];
}
- (MKMapRect)mapRectThatFits:(MKMapRect)mapRect edgePadding:(UIEdgeInsets)insets {
    return [self.mapView mapRectThatFits:mapRect edgePadding:insets];
}
#else
- (void)setVisibleMapRect:(MKMapRect)mapRect edgePadding:(NSEdgeInsets)insets animated:(BOOL)animate {
    [self.mapView setVisibleMapRect:mapRect edgePadding:insets animated:animate];
}
- (MKMapRect)mapRectThatFits:(MKMapRect)mapRect edgePadding:(NSEdgeInsets)insets {
    return [self.mapView mapRectThatFits:mapRect edgePadding:insets];
}
#endif

//@property (nonatomic, copy) MKMapCamera *camera NS_AVAILABLE(10_9, 7_0);
- (MKMapCamera *)camera {
    return self.mapView.camera;
}
- (void)setCamera:(MKMapCamera *)camera {
    [self.mapView setCamera:camera];
}
- (void)setCamera:(MKMapCamera *)camera animated:(BOOL)animated NS_AVAILABLE(10_9, 7_0) {
    [self.mapView setCamera:camera animated:animated];
}

#if TARGET_OS_IPHONE
- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(UIView *)view {
    return [self.mapView convertCoordinate:coordinate toPointToView:view];
}
- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(UIView *)view {
    return [self.mapView convertPoint:point toCoordinateFromView:view];
}
- (CGRect)convertRegion:(MKCoordinateRegion)region toRectToView:(UIView *)view {
    return [self.mapView convertRegion:region toRectToView:view];
}
- (MKCoordinateRegion)convertRect:(CGRect)rect toRegionFromView:(UIView *)view {
    return [self.mapView convertRect:rect toRegionFromView:view];
}
#else
- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(NSView *)view {
    return [self.mapView convertCoordinate:coordinate toPointToView:view];
}
- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(NSView *)view {
    return [self.mapView convertPoint:point toCoordinateFromView:view];
}
- (CGRect)convertRegion:(MKCoordinateRegion)region toRectToView:(NSView *)view {
    return [self.mapView convertRegion:region toRectToView:view];
}
- (MKCoordinateRegion)convertRect:(CGRect)rect toRegionFromView:(NSView *)view {
    return [self.mapView convertRect:rect toRegionFromView:view];
}
#endif

- (BOOL)isZoomEnabled {
    return self.mapView.zoomEnabled;
}
- (void)setZoomEnabled:(BOOL)zoomEnabled {
    [self.mapView setZoomEnabled:zoomEnabled];
}

- (BOOL)isScrollEnabled {
    return self.mapView.scrollEnabled;
}

- (void)setScrollEnabled:(BOOL)scrollEnabled {
    [self.mapView setScrollEnabled:scrollEnabled];
}

- (BOOL)isRotateEnabled {
    return self.mapView.rotateEnabled;
}
- (void)setRotateEnabled:(BOOL)rotateEnabled {
    [self.mapView setRotateEnabled:rotateEnabled];
}

- (BOOL)isPitchEnabled {
    return self.mapView.pitchEnabled;
}
- (void)setPitchEnabled:(BOOL)pitchEnabled {
    [self.mapView setPitchEnabled:pitchEnabled];
}

#if !TARGET_OS_IPHONE
- (BOOL)showsCompass {
    return self.mapView.showsCompass;
}
- (void)setShowsCompass:(BOOL)showsCompass {
    [self.mapView setShowsCompass:showsCompass];
}
- (BOOL)showsZoomControls {
    return self.mapView.showsZoomControls;
}
- (void)setShowsZoomControls:(BOOL)showsZoomControls {
    [self.mapView setShowsZoomControls:showsZoomControls];
}
- (BOOL)showsScale {
    return self.mapView.showsScale;
}
- (void)setShowsScale:(BOOL)showsScale {
    [self.mapView setShowsScale:showsScale];
}

#endif
- (BOOL)showsPointsOfInterest {
    return self.mapView.showsPointsOfInterest;
}
- (void)setShowsPointsOfInterest:(BOOL)showsPointsOfInterest {
    [self.mapView setShowsPointsOfInterest:showsPointsOfInterest];
}

- (BOOL)showsBuildings {
    return self.mapView.showsBuildings;
}
- (void)setShowsBuildings:(BOOL)showsBuildings {
    [self.mapView setShowsBuildings:showsBuildings];
}

//@property (nonatomic) BOOL showsUserLocation;
- (BOOL)showsUserLocation {
    return self.mapView.showsUserLocation;
}

- (void)setShowsUserLocation:(BOOL)showsUserLocation {
    [self.mapView setShowsUserLocation:showsUserLocation];
}

- (MKUserLocation *)userLocation {
    return self.mapView.userLocation;
    //    return nil;
}

#if TARGET_OS_IPHONE
//@property (nonatomic) MKUserTrackingMode userTrackingMode NS_AVAILABLE(NA, 5_0);
- (MKUserTrackingMode)userTrackingMode {
    return self.mapView.userTrackingMode;
}

- (void)setUserTrackingMode:(MKUserTrackingMode)userTrackingMode {
    [self.mapView setUserTrackingMode:userTrackingMode];
}
- (void)setUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated {
    [self.mapView setUserTrackingMode:mode animated:animated];
}

#endif

- (BOOL)isUserLocationVisible {
    return self.mapView.userLocationVisible;
}

- (NSSet *)annotationsInMapRect:(MKMapRect)mapRect {
    return [self.mapView annotationsInMapRect:mapRect];
}

- (MKAnnotationView *)viewForAnnotation:(id<MKAnnotation>)annotation {
    return [self.mapView viewForAnnotation:annotation];
}

- (MKAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier {
    return [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
}

- (void)selectAnnotation:(id<MKAnnotation>)annotation animated:(BOOL)animated {
    [self.mapView selectAnnotation:annotation animated:animated];
}
- (void)deselectAnnotation:(id<MKAnnotation>)annotation animated:(BOOL)animated {
    [self.mapView deselectAnnotation:annotation animated:animated];
}

- (NSArray *)selectedAnnotations {
    return self.mapView.selectedAnnotations;
}
- (void)setSelectedAnnotations:(NSArray *)selectedAnnotations {
    [self.mapView setSelectedAnnotations:selectedAnnotations];
}

- (CGRect)annotationVisibleRect {
    return self.mapView.annotationVisibleRect;
}

- (void)showAnnotations:(NSArray *)annotations animated:(BOOL)animated NS_AVAILABLE(10_9, 7_0) {
    [self.mapView showAnnotations:annotations animated:animated];
}

@end

@implementation VWWClusteredMapView (OverlaysAPI)

// Overlays are models used to represent areas to be drawn on top of the map.
// This is in contrast to annotations, which represent points on the map.
// Implement -mapView:rendererForOverlay: on MKMapViewDelegate to return the renderer for each overlay.
- (void)addOverlay:(id<MKOverlay>)overlay level:(MKOverlayLevel)level NS_AVAILABLE(10_9, 7_0) {
    [self.mapView addOverlay:overlay level:level];
}
- (void)addOverlays:(NSArray *)overlays level:(MKOverlayLevel)level NS_AVAILABLE(10_9, 7_0) {
    [self.mapView addOverlays:overlays level:level];
}

- (void)removeOverlay:(id<MKOverlay>)overlay NS_AVAILABLE(10_9, 4_0) {
    [self.mapView removeOverlay:overlay];
}
- (void)removeOverlays:(NSArray *)overlays NS_AVAILABLE(10_9, 4_0) {
    [self.mapView removeOverlays:overlays];
}

- (void)insertOverlay:(id<MKOverlay>)overlay atIndex:(NSUInteger)index level:(MKOverlayLevel)level NS_AVAILABLE(10_9, 7_0) {
    [self.mapView insertOverlay:overlay atIndex:index level:level];
}

- (void)insertOverlay:(id<MKOverlay>)overlay aboveOverlay:(id<MKOverlay>)sibling NS_AVAILABLE(10_9, 4_0) {
    [self.mapView insertOverlay:overlay aboveOverlay:sibling];
}
- (void)insertOverlay:(id<MKOverlay>)overlay belowOverlay:(id<MKOverlay>)sibling NS_AVAILABLE(10_9, 4_0) {
    [self.mapView insertOverlay:overlay belowOverlay:sibling];
}

- (void)exchangeOverlay:(id<MKOverlay>)overlay1 withOverlay:(id<MKOverlay>)overlay2 NS_AVAILABLE(10_9, 7_0) {
    [self.mapView exchangeOverlay:overlay1 withOverlay:overlay2];
}

- (NSArray *)overlays {
    return self.mapView.overlays;
}
- (NSArray *)overlaysInLevel:(MKOverlayLevel)level NS_AVAILABLE(10_9, 7_0) {
    return [self.mapView overlaysInLevel:level];
}

- (MKOverlayRenderer *)rendererForOverlay:(id<MKOverlay>)overlay NS_AVAILABLE(10_9, 7_0) {
    return [self.mapView rendererForOverlay:overlay];
}

#if TARGET_OS_IPHONE
// Currently displayed view for overlay; returns nil if the view has not been created yet.
// Prefer using MKOverlayRenderer and -rendererForOverlay.
- (MKOverlayView *)viewForOverlay:(id<MKOverlay>)overlay NS_DEPRECATED_IOS(4_0, 7_0) {
    return [self.mapView viewForOverlay:overlay];
}
#endif

// These methods operate implicitly on overlays in MKOverlayLevelAboveLabels and may be deprecated in a future release in favor of the methods that specify the level.
- (void)addOverlay:(id<MKOverlay>)overlay NS_AVAILABLE(10_9, 4_0) {
    [self.mapView addOverlay:overlay];
}
- (void)addOverlays:(NSArray *)overlays NS_AVAILABLE(10_9, 4_0) {
    [self.mapView addOverlays:overlays];
}

- (void)insertOverlay:(id<MKOverlay>)overlay atIndex:(NSUInteger)index NS_AVAILABLE(10_9, 4_0) {
    [self.mapView insertOverlay:overlay atIndex:index];
}
- (void)exchangeOverlayAtIndex:(NSUInteger)index1 withOverlayAtIndex:(NSUInteger)index2 NS_AVAILABLE(10_9, 4_0) {
    [self.mapView exchangeOverlayAtIndex:index1 withOverlayAtIndex:index2];
}

@end
