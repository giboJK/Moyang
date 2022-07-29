//
//  CommunityMainScrollView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/25.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class CommunityMainScrollView: UIView {
    typealias VM = CommunityMainVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    let container = UIView()
    
    required init(disposeBag: DisposeBag) {
        
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupScrollView()
    }
    
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalTo(safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(container)
        container.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide).priority(250)
        }
    }
}
