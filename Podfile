# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!

def etc
  pod 'SwiftyBeaver'
  pod 'SwiftGen'
  pod 'SwiftLint'
end

def db
  pod 'RealmSwift'
end

def network
  pod 'Alamofire'
end

target 'Moyang' do
  inhibit_all_warnings!

  etc
  
  db
  
  network
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'YES'
      end
    end
  end
  
  target 'MoyangTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MoyangUITests' do
    # Pods for testing
  end

end
