//
//  TaskListView.swift
//  Moyang
//
//  Created by kibo on 2022/08/10.
//

import UIKit
import RxSwift
import SnapKit
import Then
import RxCocoa

class TaskListView: UIView {
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
    }
}
