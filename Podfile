# BUG: Specifying deployment target doesn't work.
#      http://groups.google.com/group/cocoapods/browse_thread/thread/d3761ac18d9c0ec6
platform :ios, :deployment_target => "5.0"

dependency 'SBJson', '2.2.3'
dependency 'MBProgressHUD', '0.41'

# BUG: RestKit's podspec doesn't include CoreData/CoreData.h because it conflicts with Apple CoreData/CoreData.h
#      http://groups.google.com/group/cocoapods/browse_thread/thread/705f040f2e7aa03d
# BUG: Specifying a podspec which contains subspecs throws exception.
#      https://github.com/CocoaPods/CocoaPods/issues/141
#
# rk = "RestKit-Custom-0.9.3.podspec"
# dependency 'RestKit/Network', :podspec => rk
# dependency 'RestKit/ObjectMapping', :podspec => rk
# dependency 'RestKit/CoreData', :podspec => rk
# dependency 'RestKit/ObjectMapping/JSONKit', :podspec => rk

dependency 'RestKit/Network', '0.9.4'
dependency 'RestKit/ObjectMapping', '0.9.4'
dependency 'RestKit/CoreData', '0.9.4'
dependency 'RestKit/ObjectMapping/JSONKit', '0.9.4'


# TODO: Replace with BlocksKit?
dependency do |s|
  s.name = 'MRCEnumerable'
  s.version = '0.1'
  s.platform = :ios
  s.source = { :git => 'https://github.com/crafterm/MRCEnumerable.git', :commit => '15db6f3e48c5483d9635257511366864072ea016' }
  s.source_files = '*.{h,m}'
end

# TODO: Add to cocoapods specs repo or NUSurveyor project
dependency do |s|
  s.name = 'NUSurveyor'
  s.version = '0.0.0'
  s.platform = :ios
  s.requires_arc = true
  s.source = { :git => 'https://github.com/NUBIC/nu_surveyor.git', :commit => 'f751b7313cd8d15ba58f116a6f6551605ec5ab56' }
  s.source_files = 'NUSurveyor/NUConstants.h', 'NUSurveyor/**/*.{h,m}'
  s.frameworks = 'QuartzCore', 'CoreGraphics'
  def s.post_install(target)
    prefix_header = config.project_pods_root + target.prefix_header_filename
    prefix_header.open('a') do |file|
      file.puts(%{#ifdef __OBJC__\n#import "NUConstants.h"\n#endif})
    end
  end
end

# TODO: Add NUCas
