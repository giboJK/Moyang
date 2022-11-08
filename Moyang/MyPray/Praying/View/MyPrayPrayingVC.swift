//
//  MyPrayPrayingVC.swift
//  Moyang
//
//  Created by kibo on 2022/11/08.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import MarqueeLabel

class MyPrayPrayingVC: UIViewController, VCType {
    typealias VM = MyPrayPrayingVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: MyPrayPrayingVCDelegate?

    // MARK: - UI
    let timeLabel = MoyangLabel()
    let songNameLabel = MarqueeLabel.init(frame: .zero, duration: 10.0, fadeLength: 0.0)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }

    deinit { Log.i(self) }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupUI() {
        title = "기도"
        view.backgroundColor = .nightSky1
    }

    // MARK: - Binding
    func bind() {
        bindVM()
    }
    private func bindViews() {

    }

    private func bindVM() {
    }
}

protocol MyPrayPrayingVCDelegate: AnyObject {

}
