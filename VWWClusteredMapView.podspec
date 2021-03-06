
# This pod is not published on trunk yet. You can use it by adding this to your podfile:
#pod 'VWWClusteredMapView', :git => 'https://github.com/zakkhoyt/VWWClusteredMapView', :branch => 'cocoapods'

Pod::Spec.new do |s|
  s.name         = "VWWClusteredMapView"
  s.version      = "1.0.3"
  s.summary      = "MKMapView with annotation clustering"
  s.author        = { "Zakk Hoyt" => "vaporwarewolf@gmail.com" }
  s.homepage      = "http://github.com/zakkhoyt/VWWClusteredMapView"
  s.platforms = { :ios => 8.0, 
                  :tvos => 9.2,
                  :osx => 10.10
                }

  s.license = { :type => 'MIT',
                :text =>  <<-LICENSE
                  Copyright 2015. Zakk hoyt.
                          LICENSE
              }
  s.source       = { :git => 'https://github.com/zakkhoyt/VWWClusteredMapView.git',
                    :tag =>  "#{s.version}" }
  s.source_files  = 'VWWClusteredMapView/**/*.{h,m}'
  s.resources = 'VWWClusteredMapView/**/*.{xib}'
  s.requires_arc = true
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.2'
  s.osx.deployment_target = '10.10'
end
