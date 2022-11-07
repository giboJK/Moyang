//
//  MyPrayBottomView.swift
//  Moyang
//
//  Created by kibo on 2022/11/07.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit


class MyPrayBottomView: UIView {
    let prayButton = MoyangButton(.nightPrimary).then {
        $0.setTitle("기도하기", for: .normal)
    }
    let deleteContainer = UIView()
    let deleteImageView = UIImageView(image: UIImage(systemName: "trash")).then {
        $0.tintColor = .appleRed1
    }
    let deleteLabel = MoyangLabel().then {
        $0.text = "기도삭제"
        $0.textColor = .appleRed1
        $0.font = .b01
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .sheep2
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupPrayButton()
        setupDeleteContainer()
    }
    private func setupPrayButton() {
        addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(36)
            $0.top.equalToSuperview().inset(12)
            $0.right.equalToSuperview().inset(24)
        }
    }
    private func setupDeleteContainer() {
        addSubview(deleteContainer)
        deleteContainer.snp.makeConstraints {
            $0.left.equalToSuperview().inset(24)
            $0.centerY.equalTo(prayButton)
        }
        setupDeleteImageView()
        setupDeleteLabel()
    }
    private func setupDeleteImageView() {
        deleteContainer.addSubview(deleteImageView)
        deleteImageView.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.size.equalTo(20)
        }
    }
    private func setupDeleteLabel() {
        deleteContainer.addSubview(deleteLabel)
        deleteLabel.snp.makeConstraints {
            $0.left.equalTo(deleteImageView.snp.right).offset(8)
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}
