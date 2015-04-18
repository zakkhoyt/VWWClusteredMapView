






# This pod is not published on trunk yet. YOu can use it by adding this to your podfile:
# pod 'VWWClusteredMapView', :podspec => "https://raw.githubusercontent.com/zakkhoyt/VWWClusteredMapView/master/VWWClusteredMapView.podspec"


Pod::Spec.new do |s|
  s.name         = "VWWClusteredMapView"
  s.version      = "0.0.5"
  s.summary      = "MKMapView which automatically clusters your annotations into groups with some light animation"
  s.author        = { "Zakk Hoyt" => "vaporwarewolf@gmail.com" }
  s.homepage      = "http://github.com/zakkhoyt"
  s.license = { :type => 'MIT',
                :text =>  <<-LICENSE
                  Copyright 2015. Zakk hoyt.
                          LICENSE
              }
  s.source       = { :git => 'https://github.com/zakkhoyt/VWWClusteredMapView.git',
                    :tag =>  "#{s.version}" }
  s.source_files  = 'VWWClusteredMapView/**/*.{h,m}'
  s.requires_arc = true
  s.ios.deployment_target = '8.0'

  # Coming soon...
  # s.osx.deployment_target = '10.10'
end
