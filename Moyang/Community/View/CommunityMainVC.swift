//
//  CommunityMainVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/14.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SwiftUI
import SnapKit

class CommunityMainVC: UIViewController, VCType {
    typealias VM = CommunityMainVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: CommunityMainVM?
    
    // MARK: - UI
    let sermonCard = SermonCard()
    lazy var scrollView = CommunityMainScrollView(disposeBag: disposeBag)
    let contentView = UIHostingController(rootView: CommunityMainView())

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

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func setupUI() {
        title = "공동체"
        view.backgroundColor = .nightSky3
        setupSermonCard()
        setupScrollView()
//        addChild(contentView)
//        view.addSubview(contentView.view)
//        setupConstraints()
    }
    
    private func setupSermonCard() {
        view.addSubview(sermonCard)
        sermonCard.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(240)
        }
    }
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(sermonCard.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        scrollView.layer.cornerRadius = 16
        scrollView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        scrollView.layer.masksToBounds = true
        scrollView.backgroundColor = .sheep2
    }
    
    fileprivate func setupConstraints() {
        contentView.view.translatesAutoresizingMaskIntoConstraints = false
        contentView.view.snp.makeConstraints {
            $0.top.equalTo(sermonCard.snp.bottom).offset(20)
            $0.left.right.left.equalToSuperview()
        }
    }
    
    func bind() {
        // Do nothing
    }
}
