//
//  WorshipNoteHeader.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/10.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class WorshipNoteHeader: UIView {
    let newFolderButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "folder.fill.badge.plus", withConfiguration: config), for: .normal)
        $0.tintColor = .sheep1
    }
    let newMemoButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "square.and.pencil", withConfiguration: config), for: .normal)
        $0.tintColor = .sheep1
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .nightSky1
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupNewMemoButton()
        setupNewFolderButton()
    }
    private func setupNewMemoButton() {
        addSubview(newMemoButton)
        newMemoButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(12)
            $0.size.equalTo(24)
            $0.right.equalToSuperview().inset(20)
        }
    }
    private func setupNewFolderButton() {
        addSubview(newFolderButton)
        newFolderButton.snp.makeConstraints {
            $0.width.equalTo(24)
            $0.height.equalTo(20)
            $0.right.equalTo(newMemoButton.snp.left).offset(-20)
            $0.centerY.equalTo(newMemoButton)
        }
    }
}
