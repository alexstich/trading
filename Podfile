# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'trading' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Starscream', '~>4.0.4'
  pod 'RxSwift', '~>6.5.0'
  pod "Kingfisher", '~>6.3.1'
  pod 'SnapKit', '~>5.6.0'
  pod 'DeepDiff', '~>2.3.1'
  # Pods for trading

end

post_install do |installer|
 installer.pods_project.targets.each do |target|
  target.build_configurations.each do |config|
   config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
  end
 end
end
