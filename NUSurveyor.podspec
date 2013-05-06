Pod::Spec.new do |s|
  s.name = 'NUSurveyor'
  s.version = '1.1.dev22'
  s.platform = :ios
  s.requires_arc = true
  s.source = { :git => 'git@github.com:jacobvanorder/nu_surveyor.git', :commit => '89703b1a7a96bc88c3847ffe339ed1ef2dd613c9' }
  s.source_files = 'NUSurveyor/NUSurveyor-Prefix.pch', 'NUSurveyor/**/*.{h,m}', 'GR*.{h,m}'
  s.frameworks = 'QuartzCore', 'CoreGraphics'
  s.preserve_paths = 'libGRMustache5-iOS.a'
  s.library = 'GRMustache5-iOS'
  s.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '"$(PODS_ROOT)/NUSurveyor"' } 
  s.prefix_header_file = 'NUSurveyor/NUSurveyor-Prefix.pch' 
end
