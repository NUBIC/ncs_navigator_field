Pod::Spec.new do |s|
  s.name = 'NUSurveyor'
  s.version = '1.1.dev23'
  s.platform = :ios
  s.requires_arc = true
  s.source = { :git => 'git@github.com:jacobvanorder/nu_surveyor.git', :commit => 'a0c36f190af9c99292378eb9ef37dd588609a82e' }
  s.source_files = 'NUSurveyor/NUSurveyor-Prefix.pch', 'NUSurveyor/**/*.{h,m}', 'GR*.{h,m}'
  s.frameworks = 'QuartzCore', 'CoreGraphics'
  s.preserve_paths = 'libGRMustache5-iOS.a'
  s.library = 'GRMustache5-iOS'
  s.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '"$(PODS_ROOT)/NUSurveyor"' } 
  s.prefix_header_file = 'NUSurveyor/NUSurveyor-Prefix.pch' 
end
