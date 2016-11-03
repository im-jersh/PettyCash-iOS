source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'PettyCash' do

    pod 'PathMenu'
    pod 'Eureka', '~> 2.0.0-beta.1'
    pod 'ChameleonFramework/Swift'
    pod 'DZNEmptyDataSet'
    pod 'SlideMenuControllerSwift'
    pod 'MBCircularProgressBar'
    pod 'plaid-ios-sdk'
end

target 'PettyCashTests' do
    pod 'PathMenu'
    pod 'ChameleonFramework/Swift'
    pod 'DZNEmptyDataSet'
    pod 'SlideMenuControllerSwift'
    pod 'plaid-ios-sdk'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
