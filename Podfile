# Uncomment the next line to define a global platform for your project
platform :ios, '15.6'

target 'EkyPOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git'
  pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit.git'
  pod 'RealmSwift', :git => 'https://github.com/realm/realm-swift.git'
  # https://github.com/groue/GRDB.swift
  # https://github.com/stephencelis/SQLite.swift
  # pod 'SideMenuSwift', :git => 'https://github.com/kukushi/SideMenu.git'
  pod 'SideMenu', :git => 'https://github.com/jonkykong/SideMenu.git', :tag => '6.5.0'
  
  pod 'AwaitToast', :git => 'https://github.com/k-lpmg/AwaitToast.git', :tag => '1.2.0'
  # https://github.com/devxoul/Toaster
  # pod 'NotificationBannerSwift', :git => 'https://github.com/Daltron/NotificationBanner.git', :tag => '4.0.0'

  # https://github.com/joomcode/BottomSheet
  # https://github.com/SCENEE/FloatingPanel

  pod 'ViewAnimator', :git => 'https://github.com/marcosgriselli/ViewAnimator.git', :tag => '3.1.0'
  # https://github.com/HeroTransitions/Hero

  pod 'IGListKit', :git => 'https://github.com/Instagram/IGListKit.git', :tag => '5.0.0'
  
  # pod 'Device', :git => 'https://github.com/Ekhoo/Device.git', :tag => '3.7.0'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.6'
    end
  end
end

# .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.7.1")),
# .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.10.2")),
# .package(url: "https://github.com/stephencelis/SQLite.swift.git", .upToNextMajor(from: "0.15.4")),