Pod::Spec.new do |s|
  s.name = 'NUSurveyor'
  s.version = '1.1.dev17'
  s.platform = :ios
  s.requires_arc = true
  s.source = { :git => 'https://github.com/NUBIC/nu_surveyor.git', :commit => '4285c3b2246c149eddcfe38351b51297ef286d5f' }
  s.source_files = 'NUSurveyor/NUSurveyor-Prefix.pch', 'NUSurveyor/**/*.{h,m}', 'GR*.{h,m}'
  s.frameworks = 'QuartzCore', 'CoreGraphics'
  s.preserve_paths = 'libGRMustache5-iOS.a'
  s.library = 'GRMustache5-iOS'
  s.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '"$(PODS_ROOT)/NUSurveyor"' } 
  s.prefix_header_file = 'NUSurveyor/NUSurveyor-Prefix.pch' 
end
