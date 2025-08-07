# Uncomment the next line to define a global platform for your project
platform :ios, '15.6'

target 'EkyPOS' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for EkyPOS
  pod 'SnapKit', :git => 'https://github.com/SnapKit/SnapKit.git'
  pod 'RealmSwift', :git => 'https://github.com/realm/realm-swift.git'
  # https://github.com/groue/GRDB.swift
  # https://github.com/stephencelis/SQLite.swift
  pod 'SideMenuSwift', :git => 'https://github.com/kukushi/SideMenu.git'
  pod 'AwaitToast', :git => 'https://github.com/k-lpmg/AwaitToast.git'
  # https://github.com/devxoul/Toaster
  # https://github.com/Daltron/NotificationBanner

  # https://github.com/joomcode/BottomSheet
  # https://github.com/SCENEE/FloatingPanel

  # https://github.com/marcosgriselli/ViewAnimator
  # https://github.com/HeroTransitions/Hero
  
  # https://github.com/Ekhoo/Device
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.6'
    end
  end
end

