







Pod::Spec.new do |s|
  s.name         = "VWWClusteredMapView"
  s.version      = "0.0.2"
  s.summary      = "MKMapView where annotations can snap to edge of the map and automatically cluster as the user zooms"
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
  #s.osx.deployment_target = '10.10'
end
