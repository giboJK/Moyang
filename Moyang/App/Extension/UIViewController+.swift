//
//  UIViewController+.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture

var popupArray = [MoyangPopupView]()

class PopupVC: UIViewController {
    
    static let shared = PopupVC()
    var disposebag = DisposeBag()
    var backgroundTapHandler: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.modalPresentationStyle = .overFullScreen
        
        self.view.rx.tapGesture().skip(1).bind(onNext: { _ in
            self.backgroundTapHandler?()
        }).disposed(by: disposebag)
    }
}

extension UIViewController {
    func displayPopup(popup: MoyangPopupView, backAlpha: CGFloat = 0.5) {
        if popupArray.contains(popup) {
            return
        }
        
        DispatchQueue.main.async {
            PopupVC.shared.view.addSubview(popup)
            popup.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            popupArray.append(popup)
            self.present(PopupVC.shared, animated: false, completion: nil)
            
            popup.backgroundColor = UIColor.black.withAlphaComponent(backAlpha)
            popup.isHidden = false
        }
    }
    
    func closePopup(completion: (() -> Void)? = nil ) {
        DispatchQueue.main.async {
            popupArray.removeAll()
            
            for v in PopupVC.shared.view.subviews {
                v.removeFromSuperview()
            }
            PopupVC.shared.dismiss(animated: false)
            
            completion?()
        }
    }
}

extension UIViewController {
    func showToast(type: ToastType,
                   message: String,
                   font: UIFont = .systemFont(ofSize: 15, weight: .regular),
                   textColor: UIColor = .sheep1, disposeBag: DisposeBag) {
        let toastView = UIView(frame: CGRect(x: 0,
                                             y: -(UIApplication.statusBarHeight + 44),
                                             width: UIScreen.main.bounds.width,
                                             height: UIApplication.statusBarHeight + 44))
        if type == .success {
            toastView.backgroundColor = .ydGreen1
        } else {
            toastView.backgroundColor = .appleRed1
        }
        
        let toastLabel = UILabel(frame: CGRect(x: 20,
                                               y: UIApplication.statusBarHeight + 12,
                                               width: UIScreen.main.bounds.width - 40,
                                               height: 20))
        toastLabel.textColor = textColor
        toastLabel.font = font
        toastLabel.text = message
        self.view.addSubview(toastView)
        toastView.addSubview(toastLabel)
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
            toastView.frame = CGRect(x: 0,
                                     y: 0,
                                     width: UIScreen.main.bounds.width,
                                     height: UIApplication.statusBarHeight + 44)
        }, completion: nil)
        
        var timer: Timer?
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            UIView.animate(withDuration: 0.2, animations: {
                toastView.frame = CGRect(x: 0,
                                         y: -(UIApplication.statusBarHeight + 44),
                                         width: UIScreen.main.bounds.width,
                                         height: UIApplication.statusBarHeight + 44)
            }, completion: { _ in
                toastView.removeFromSuperview()
                timer?.invalidate()
            })
        }
        
        toastView.rx
            .swipeGesture(.up)
            .when(.recognized)
            .subscribe(onNext: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    toastView.frame = CGRect(x: 0,
                                             y: -(UIApplication.statusBarHeight + 44),
                                             width: UIScreen.main.bounds.width,
                                             height: UIApplication.statusBarHeight + 44)
                }, completion: { _ in
                    toastView.removeFromSuperview()
                    
                    timer?.invalidate()
                })
            }).disposed(by: disposeBag)
    }
    
    enum ToastType {
        case success
        case failure
    }
}

extension RxSwift.Reactive where Base: UIViewController {
    var viewDidAppear: Observable<Bool> {
    return methodInvoked(#selector(UIViewController.viewDidAppear))
       .map { $0.first as? Bool ?? false }
    }
    
    var viewWillAppear: Observable<Bool> {
    return methodInvoked(#selector(UIViewController.viewWillAppear))
       .map { $0.first as? Bool ?? false }
    }
    
    var viewDidDisappear: Observable<Bool> {
    return methodInvoked(#selector(UIViewController.viewDidDisappear))
       .map { $0.first as? Bool ?? false }
    }
}
