# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
use_frameworks!
target 'Brain Challenge' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  

  # Pods for Brain Challenge
  pod 'IBAnimatable'
  pod 'MBProgressHUD'
  pod 'AlamofireObjectMapper', '~> 4.0'
  pod 'FacebookCore'
  pod 'FacebookLogin'
  pod 'FacebookShare'
  pod 'Fabric'
  pod 'TwitterKit'
  pod 'Kingfisher', '~> 3.0'
  pod 'RealmSwift'
  pod 'Socket.IO-Client-Swift', '~> 8.2.0'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end