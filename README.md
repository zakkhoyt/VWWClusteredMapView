# VWWClusteredMapView

## Overview

`VWWClusteredMapView` works just like 'MKMapView' but can cluster your annotations when they overlap (this can be turned off for normal MKMapView behavior). VWWClusteredMapView provides all the same delegate protocol as MKMapViewDelegate with the addition of a few extra methods for clustered annotations:

```
- (VWWClusteredAnnotationView *)clusteredMapView:(VWWClusteredMapView *)clusteredMapView viewForClusteredAnnotation:(id <MKAnnotation>)annotation;
```
```
- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView didSelectClusteredAnnotationView:(VWWClusteredAnnotationView *)view NS_AVAILABLE(10_9, 4_0);
```
```
- (void)clusteredMapView:(VWWClusteredMapView *)clusteredMapView didDeselectClusteredAnnotationView:(VWWClusteredAnnotationView *)view NS_AVAILABLE(10_9, 4_0);
```

## Example Project

To run the example project, clone this repository then open VWWClusteredMapViewExample.xcodeproj 

## Cocoapods

VWWClusteredMapView is available through [CocoaPods](http://cocoapods.org).   
To install it, simply add the following line to your Podfile:

```ruby
pod 'VWWClusteredMapView', :podspec => "https://raw.githubusercontent.com/zakkhoyt/VWWClusteredMapView/0.0.6/VWWClusteredMapView.podspec"
```

then run 
```
pod install
```


## Requirements

- iOS 8.0 or higher 

## License

VWWClusteredMapView is available under the MIT license.
