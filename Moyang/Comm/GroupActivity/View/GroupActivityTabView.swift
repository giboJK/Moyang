//
//  GroupActivityTabView.swift
//  Moyang
//
//  Created by kibo on 2022/09/07.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class GroupActivityTabView: UIView {
    typealias VM = GroupPrayVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .nightSky1
    }
}
