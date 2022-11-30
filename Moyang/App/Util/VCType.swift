//
//  VCType.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/14.
//

import Foundation
import UIKit
import RxSwift

protocol VCType {
    associatedtype VM
    
    var disposeBag: DisposeBag { get set }
    // MARK: - UI
    
    // MARK: - Setup UI
    func setupUI()
    // MARK: - Binding
    func bind()
}

//import UIKit
//import RxCocoa
//import RxSwift
//import SnapKit
//import Then
//
//class VC: UIViewController, VCType {
//    typealias VM = DummyVM
//    var disposeBag: DisposeBag = DisposeBag()
//    var vm: VM?
//    var coordinator: VCDelegate?
//
//    // MARK: - UI
//
//    let indicator = UIActivityIndicatorView(style: .large).then {
//        $0.hidesWhenStopped = true
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupUI()
//        bind()
//    }
//
//    deinit { Log.i(self) }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        .lightContent
//    }
//    func setupUI() {
//        setupIndicator()
//    }
//    private func setupIndicator() {
//        view.addSubview(indicator)
//        indicator.snp.makeConstraints {
//            $0.size.equalTo(60)
//            $0.center.equalToSuperview()
//        }
//    }
//
//    // MARK: - Binding
//    func bind() {
//        bindVM()
//    }
//    private func bindViews() {
//
//    }
//
//    private func bindVM() {
////        guard let vm = vm else { Log.e("vm is nil"); return }
////        let input = VM.Input()
//    }
//}
//
//protocol VCDelegate: AnyObject {
//
//}
