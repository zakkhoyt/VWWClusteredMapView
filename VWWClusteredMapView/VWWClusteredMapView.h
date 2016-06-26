//
//  ClusteredMapView.h
//  VWWClusteredMapView
//
//  Created by Zakk Hoyt on 3/28/15.
//  Copyright (c) 2015 Zakk Hoyt. All rights reserved.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "VWWClusteredAnnotation.h"
#import "VWWClusteredAnnotationView.h"

typedef NS_ENUM(NSInteger, ClusterMapViewDensity) {
    ClusterMapViewDensityWimpy = 0,
    ClusterMapViewDensityNormal,
    ClusterMapViewDensityMacho,
};

// Defined at bottom of file
@protocol VWWClusteredMapViewDataSource;
@protocol VWWClusteredMapViewDelegate;

@interface VWWClusteredMapView : UIView

// The aggressiveness of clustering
@property (nonatomic) ClusterMapViewDensity clusterDensity;

// Animate as annotations are added and removed
@property (nonatomic) BOOL animateReclusting;
@property (nonatomic) NSTimeInterval addAnnotationAnimationDuration;
@property (nonatomic) NSTimeInterval removeAnnotationAnimationDuration;

@property (nonatomic) VWWClusteredMapViewAnnotationAddAnimation addAnimationType;
@property (nonatomic) VWWClusteredMapViewAnnotationRemoveAnimation removeAnimationType;
@property (weak, nonatomic, nullable) id<VWWClusteredMapViewDataSource> dataSource;
@property (weak, nonatomic, nullable) id<VWWClusteredMapViewDelegate> delegate;

// When the user taps overlapping annotations, fan them out. Default = YES
@property (nonatomic) BOOL enableFanout;

- (void)reloadData;

// TODO: Add functions to allow inserting/deleting/moving with animation
//- (void)insertAnnotationsAtIndex:(NSInteger)index withRowAnimation:(UITableViewRowAnimation)animation;
//- (void)deleteAnnotationsAtIndex:(NSInteger)index withRowAnimation:(UITableViewRowAnimation)animation;
//- (void)reloadAnnotationsAtIndex:(NSInteger)index withRowAnimation:(UITableViewRowAnimation)animation;
//- (void)moveAnnotationsAtIndex:(NSInteger)index toIndexIndex:(NSInteger)newIndex;
@end

@interface VWWClusteredMapView (MKMapView)
// Changing the map type or region can cause the map to start loading map content.
// The loading delegate methods will be called as map content is loaded.
@property (nonatomic) MKMapType mapType;

// Region is the coordinate and span of the map.
// Region may be modified to fit the aspect ratio of the view using regionThatFits:.
@property (nonatomic) MKCoordinateRegion region;
- (void)setRegion:(MKCoordinateRegion)region animated:(BOOL)animated;

// centerCoordinate allows the coordinate of the region to be changed without changing the zoom level.
@property (nonatomic) CLLocationCoordinate2D centerCoordinate;
- (void)setCenterCoordinate:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated;

// Returns a region of the aspect ratio of the map view that contains the given region, with the same center point.
- (MKCoordinateRegion)regionThatFits:(MKCoordinateRegion)region;

// Access the visible region of the map in projected coordinates.
@property (nonatomic) MKMapRect visibleMapRect;
- (void)setVisibleMapRect:(MKMapRect)mapRect animated:(BOOL)animate;

// Returns an MKMapRect modified to fit the aspect ratio of the map.
- (MKMapRect)mapRectThatFits:(MKMapRect)mapRect;

// Edge padding is the minumum padding on each side around the specified MKMapRect.
#if TARGET_OS_IPHONE
- (void)setVisibleMapRect:(MKMapRect)mapRect edgePadding:(UIEdgeInsets)insets animated:(BOOL)animate;
- (MKMapRect)mapRectThatFits:(MKMapRect)mapRect edgePadding:(UIEdgeInsets)insets;
#else
- (void)setVisibleMapRect:(MKMapRect)mapRect edgePadding:(NSEdgeInsets)insets animated:(BOOL)animate;
- (MKMapRect)mapRectThatFits:(MKMapRect)mapRect edgePadding:(NSEdgeInsets)insets;
#endif

@property (nonatomic, copy, nullable) MKMapCamera *camera NS_AVAILABLE(10_9, 7_0);
- (void)setCamera:(MKMapCamera *)camera animated:(BOOL)animated NS_AVAILABLE(10_9, 7_0);

#if TARGET_OS_IPHONE
- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(nullable UIView *)view;
- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(nullable UIView *)view;
- (CGRect)convertRegion:(MKCoordinateRegion)region toRectToView:(nullable UIView *)view;
- (MKCoordinateRegion)convertRect:(CGRect)rect toRegionFromView:(nullable UIView *)view;
#else
- (CGPoint)convertCoordinate:(CLLocationCoordinate2D)coordinate toPointToView:(nullable NSView *)view;
- (CLLocationCoordinate2D)convertPoint:(CGPoint)point toCoordinateFromView:(nullable NSView *)view;
- (CGRect)convertRegion:(MKCoordinateRegion)region toRectToView:(nullable NSView *)view;
- (MKCoordinateRegion)convertRect:(CGRect)rect toRegionFromView:(nullable NSView *)view;
#endif

// Control the types of user interaction available
// Zoom and scroll are enabled by default.
@property (nonatomic, getter=isZoomEnabled) BOOL zoomEnabled;
@property (nonatomic, getter=isScrollEnabled) BOOL scrollEnabled;
// Rotate and pitch are enabled by default on Mac OS X and on iOS 7.0 and later.
@property (nonatomic, getter=isRotateEnabled) BOOL rotateEnabled NS_AVAILABLE(10_9, 7_0) __TVOS_PROHIBITED;
@property (nonatomic, getter=isPitchEnabled) BOOL pitchEnabled NS_AVAILABLE(10_9, 7_0) __TVOS_PROHIBITED;

#if !TARGET_OS_IPHONE
@property (nonatomic) BOOL showsCompass NS_AVAILABLE(10_9, 9_0) __TVOS_PROHIBITED;
@property (nonatomic) BOOL showsZoomControls NS_AVAILABLE(10_9, NA);
@property (nonatomic) BOOL showsScale NS_AVAILABLE(10_10, NA);
#endif

@property (nonatomic) BOOL showsPointsOfInterest NS_AVAILABLE(10_9, 7_0);  // Affects MKMapTypeStandard and MKMapTypeHybrid
@property (nonatomic) BOOL showsBuildings NS_AVAILABLE(10_9, 7_0);         // Affects MKMapTypeStandard

// Set to YES to add the user location annotation to the map and start updating its location
@property (nonatomic) BOOL showsUserLocation;

// The annotation representing the user's location
@property (nonatomic, readonly, nullable) MKUserLocation *userLocation;

#if TARGET_OS_IPHONE
@property (nonatomic) MKUserTrackingMode userTrackingMode NS_AVAILABLE(NA, 5_0);
- (void)setUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated NS_AVAILABLE(NA, 5_0);
#endif

// Returns YES if the user's location is displayed within the currently visible map region.
@property (nonatomic, readonly, getter=isUserLocationVisible) BOOL userLocationVisible;

//// These methods are not passed through to the user, but instead we use the VWWClusteredMapViewDataSource protocol
//- (void)addAnnotation:(id <MKAnnotation>)annotation;
//- (void)addAnnotations:(NSArray *)annotations;
//
//- (void)removeAnnotation:(id <MKAnnotation>)annotation;
//- (void)removeAnnotations:(NSArray *)annotations;

//@property (nonatomic, readonly) NSArray *annotations;
- (NSSet<id<MKAnnotation>> *)annotationsInMapRect:(MKMapRect)mapRect NS_AVAILABLE(10_9, 4_2);

// Currently displayed view for an annotation; returns nil if the view for the annotation isn't being displayed.
- (nullable MKAnnotationView *)viewForAnnotation:(id <MKAnnotation>)annotation;

// Used by the delegate to acquire an already allocated annotation view, in lieu of allocating a new one.
- (nullable MKAnnotationView *)dequeueReusableAnnotationViewWithIdentifier:(NSString *)identifier;

// Select or deselect a given annotation.  Asks the delegate for the corresponding annotation view if necessary.
- (void)selectAnnotation:(id <MKAnnotation>)annotation animated:(BOOL)animated;
- (void)deselectAnnotation:(nullable id <MKAnnotation>)annotation animated:(BOOL)animated;
@property (nonatomic, copy, nullable) NSArray<id<MKAnnotation>> *selectedAnnotations;

// annotationVisibleRect is the visible rect where the annotations views are currently displayed.
// The delegate can use annotationVisibleRect when animating the adding of the annotations views in mapView:didAddAnnotationViews:
@property (nonatomic, readonly) CGRect annotationVisibleRect;

// Position the map such that the provided array of annotations are all visible to the fullest extent possible.
- (void)showAnnotations:(NSArray *)annotations animated:(BOOL)animated NS_AVAILABLE(10_9, 7_0);

@end

@interface VWWClusteredMapView (MKMapView_OverlaysAPI)

// Overlays are models used to represent areas to be drawn on top of the map.
// This is in contrast to annotations, which represent points on the map.
// Implement -mapView:rendererForOverlay: on MKMapViewDelegate to return the renderer for each overlay.
- (void)addOverlay:(id <MKOverlay>)overlay level:(MKOverlayLevel)level NS_AVAILABLE(10_9, 7_0);
- (void)addOverlays:(NSArray<id<MKOverlay>> *)overlays level:(MKOverlayLevel)level NS_AVAILABLE(10_9, 7_0);

- (void)removeOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(10_9, 4_0);
- (void)removeOverlays:(NSArray<id<MKOverlay>> *)overlays NS_AVAILABLE(10_9, 4_0);

- (void)insertOverlay:(id <MKOverlay>)overlay atIndex:(NSUInteger)index level:(MKOverlayLevel)level NS_AVAILABLE(10_9, 7_0);

- (void)insertOverlay:(id <MKOverlay>)overlay aboveOverlay:(id <MKOverlay>)sibling NS_AVAILABLE(10_9, 4_0);
- (void)insertOverlay:(id <MKOverlay>)overlay belowOverlay:(id <MKOverlay>)sibling NS_AVAILABLE(10_9, 4_0);

- (void)exchangeOverlay:(id <MKOverlay>)overlay1 withOverlay:(id <MKOverlay>)overlay2 NS_AVAILABLE(10_9, 7_0);

@property (nonatomic, readonly) NSArray<id<MKOverlay>> *overlays NS_AVAILABLE(10_9, 4_0);
- (NSArray<id<MKOverlay>> *)overlaysInLevel:(MKOverlayLevel)level NS_AVAILABLE(10_9, 7_0);

// Current renderer for overlay; returns nil if the overlay is not shown.
- (nullable MKOverlayRenderer *)rendererForOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(10_9, 7_0);

#if TARGET_OS_IPHONE
// Currently displayed view for overlay; returns nil if the view has not been created yet.
// Prefer using MKOverlayRenderer and -rendererForOverlay.
- (MKOverlayView *)viewForOverlay:(id <MKOverlay>)overlay NS_DEPRECATED_IOS(4_0, 7_0) __TVOS_PROHIBITED;
#endif

// These methods operate implicitly on overlays in MKOverlayLevelAboveLabels and may be deprecated in a future release in favor of the methods that specify the level.
- (void)addOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(10_9, 4_0);
- (void)addOverlays:(NSArray<id<MKOverlay>> *)overlays NS_AVAILABLE(10_9, 4_0);

- (void)insertOverlay:(id <MKOverlay>)overlay atIndex:(NSUInteger)index NS_AVAILABLE(10_9, 4_0);
- (void)exchangeOverlayAtIndex:(NSUInteger)index1 withOverlayAtIndex:(NSUInteger)index2 NS_AVAILABLE(10_9, 4_0);

@end

@protocol VWWClusteredMapViewDataSource <NSObject>
@required

- (NSInteger)mapViewNumberOfAnnotations:(VWWClusteredMapView *)mapView;
- (id<MKAnnotation>)mapView:(VWWClusteredMapView *)mapView annotationForItemAtIndex:(NSInteger)index;

@end

@protocol VWWClusteredMapViewDelegate <NSObject>
@required

@optional
// *********************************************************
// Methods in this section are additional to MKMapViewDelegate
- (VWWClusteredAnnotationView *)clusteredMapView:(VWWClusteredMapView *)clusteredMapView viewForClusteredAnnotation:(id<MKAnnotation>)annotation;
- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView didSelectClusteredAnnotationView:(VWWClusteredAnnotationView *)view NS_AVAILABLE(10_9, 4_0);
- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView didDeselectClusteredAnnotationView:(VWWClusteredAnnotationView *)view NS_AVAILABLE(10_9, 4_0);

// *********************************************************
// Methods in this section are wrapped versions of MKMapViewDelegate
- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView regionWillChangeAnimated:(BOOL)animated;
- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView regionDidChangeAnimated:(BOOL)animated;

- (void)clusteredMapViewWillStartLoadingMap:(VWWClusteredMapView *)clusteredMapView;
- (void)clusteredMapViewDidFinishLoadingMap:(VWWClusteredMapView *)clusteredMapView;
- (void)clusteredMapViewDidFailLoadingMap:(VWWClusteredMapView *)clusteredMapView withError:(NSError *)error;

- (void)clusteredMapViewWillStartRenderingMap:(VWWClusteredMapView *)clusteredMapView NS_AVAILABLE(10_9, 7_0);
- (void)clusteredMapViewDidFinishRenderingMap:(VWWClusteredMapView *)clusteredMapView fullyRendered:(BOOL)fullyRendered NS_AVAILABLE(10_9, 7_0);

- (MKAnnotationView *)clusteredMapView:(VWWClusteredMapView *)clusteredMapView viewForAnnotation:(id<MKAnnotation>)annotation;

- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView didAddAnnotationViews:(NSArray *)views;

#if TARGET_OS_IPHONE
- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;
#endif

- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(10_9, 4_0);
- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView didDeselectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(10_9, 4_0);

- (void)clusteredMapViewWillStartLocatingUser:(VWWClusteredMapView *)clusteredMapView NS_AVAILABLE(10_9, 4_0);
- (void)clusteredMapViewDidStopLocatingUser:(VWWClusteredMapView *)clusteredMapView NS_AVAILABLE(10_9, 4_0);
- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView didUpdateUserLocation:(MKUserLocation *)userLocation NS_AVAILABLE(10_9, 4_0);
- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView didFailToLocateUserWithError:(NSError *)error NS_AVAILABLE(10_9, 4_0);

- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView annotationView:(MKAnnotationView *)view didChangeDragState:(MKAnnotationViewDragState)newState
            fromOldState:(MKAnnotationViewDragState)oldState NS_AVAILABLE(10_9, 4_0) __TVOS_PROHIBITED;

#if TARGET_OS_IPHONE
- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView didChangeUserTrackingMode:(MKUserTrackingMode)mode animated:(BOOL)animated NS_AVAILABLE(NA, 5_0);
#endif

- (MKOverlayRenderer *)clusteredMapView:(VWWClusteredMapView *)clusteredMapView rendererForOverlay:(id<MKOverlay>)overlay NS_AVAILABLE(10_9, 7_0);
- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView didAddOverlayRenderers:(NSArray *)renderers NS_AVAILABLE(10_9, 7_0);

#if TARGET_OS_IPHONE
- (MKOverlayView *)clusteredMapView:(VWWClusteredMapView *)clusteredMapView viewForOverlay:(id<MKOverlay>)overlay NS_DEPRECATED_IOS(4_0, 7_0) __TVOS_PROHIBITED;
- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView didAddOverlayViews:(NSArray *)overlayViews NS_DEPRECATED_IOS(4_0, 7_0) __TVOS_PROHIBITED;
#endif

@end
