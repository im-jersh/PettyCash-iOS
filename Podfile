platform :ios, '9.0'
use_frameworks!

target 'PettyCash' do

    pod 'PathMenu'
    pod 'Former'
    pod 'ChameleonFramework/Swift'
    pod 'DZNEmptyDataSet'

end

target 'PettyCashTests' do
    pod 'PathMenu'
    pod 'Former'
    pod 'ChameleonFramework/Swift'
    pod 'DZNEmptyDataSet'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
