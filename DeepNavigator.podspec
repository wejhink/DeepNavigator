Pod::Spec.new do |s|
  s.name             = "DeepNavigator"
  s.version          = "0.6.0"
  s.summary          = "⛵️ Elegant URL Routing for Swift"
  s.homepage         = "https://github.com/wejhink/DeepNavigator"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Jhink Solutions" => "we@jhink.com" }
  s.source           = { :git => "https://github.com/wejhink/DeepNavigator.git",
                         :tag => s.version.to_s }
  s.source_files     = "Sources/*.swift"
  s.frameworks       = 'UIKit', 'Foundation'
  s.requires_arc     = true

  s.ios.deployment_target = "8.0"
end
