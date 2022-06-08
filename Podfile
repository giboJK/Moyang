# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!

def etc
  pod 'SwiftyBeaver'
  pod 'SwiftGen', :inhibit_warnings => true
  pod 'SwiftLint'
end

def db
  pod 'RealmSwift'
end

def di
  pod 'Swinject'
  pod 'SwinjectAutoregistration', :inhibit_warnings => true
end

def rx
  pod 'RxSwift'
  pod 'RxCocoa', :inhibit_warnings => true
  pod 'RxGesture'
end

def network
  pod 'Alamofire'
  pod 'GoogleSignIn', :inhibit_warnings => true
end

def firebase
  pod 'Firebase/Auth'
  pod 'Firebase/Core'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'FirebaseFirestoreSwift'
  pod 'Firebase/Crashlytics'
end

def ui
  pod 'AlertToast'
  pod 'lottie-ios'
  pod 'MarqueeLabel'
  
  pod 'SnapKit', :inhibit_warnings => true
  pod 'Then'
end

target 'Moyang' do
  inhibit_all_warnings!

  etc
  
  db
  
  network
  
  di
  
  rx
  
  firebase
  
  ui
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'YES'
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
  
  target 'MoyangTests' do
    inherit! :search_paths
    # Pods for testing
  end
end
