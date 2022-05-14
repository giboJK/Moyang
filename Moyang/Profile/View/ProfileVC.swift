//
//  ProfileVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/14.
//

import UIKit
import RxCocoa
import RxSwift
import SwiftUI

class ProfileVC: UIViewController, VCType {
    typealias VM = DummyVM
    // MARK: - Properties
    var disposeBag: DisposeBag = DisposeBag()

    // MARK: - UI
    let contentView = UIHostingController(rootView: ProfileView())

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }

    deinit { Log.i(self) }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    func setupUI() {
        title = "내 정보"
        addChild(contentView)
        view.addSubview(contentView.view)
        setupConstraints()
    }
    
    fileprivate func setupConstraints() {
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func bind() {
        // Do nothing
    }
}
