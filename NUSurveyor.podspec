Pod::Spec.new do |s|
  s.name = 'NUSurveyor'
  s.version = '1.1.dev4'
  s.platform = :ios
  s.requires_arc = true
  s.source = { :git => 'https://github.com/NUBIC/nu_surveyor.git', :commit => 'b794924ce361d77eb12af35038819e327361b880' }
  s.source_files = 'NUSurveyor/NUSurveyor-Prefix.pch', 'NUSurveyor/**/*.{h,m}', 'GR*.{h,m}'
  s.frameworks = 'QuartzCore', 'CoreGraphics'
  s.preserve_paths = 'libGRMustache5-iOS.a'
  s.library = 'GRMustache5-iOS'
  s.xcconfig = { 'LIBRARY_SEARCH_PATHS' => '"$(PODS_ROOT)/NUSurveyor"' } 
  s.prefix_header_file = 'NUSurveyor/NUSurveyor-Prefix.pch' 
end
