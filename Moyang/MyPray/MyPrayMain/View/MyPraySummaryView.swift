//
//  MyPraySummaryView.swift
//  Moyang
//
//  Created by kibo on 2022/11/01.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class MyPraySummaryView: UIView {
    
    // MARK: - UI
    
    let myLatestPrayView = MyLatestPrayView()
    
    let showAllView = ShowAllView()
    
    let addNewPrayView = AddNewPrayView()
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .nightSky1
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupMyLatestPrayView()
        setupShowAllView()
        setupAddNewPrayView()
    }
    private func setupMyLatestPrayView() {
        addSubview(myLatestPrayView)
        myLatestPrayView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
    }
    
    private func setupShowAllView() {
        addSubview(showAllView)
        showAllView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(myLatestPrayView.snp.bottom).offset(24)
        }
    }
    private func setupAddNewPrayView() {
        addSubview(addNewPrayView)
        addNewPrayView.snp.makeConstraints {
            $0.top.equalTo(showAllView.snp.bottom).offset(28)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - MyLatestPrayView
class MyLatestPrayView: UIView {
    let forwardImageView = UIImageView(image: UIImage(systemName: "chevron.forward")).then {
        $0.tintColor = .sheep3
    }
    let dateLabel = MoyangLabel()
    let titleLabel = MoyangLabel()
    let contentLabel = MoyangLabel()
    let latestPrayDateLabel = MoyangLabel()
    let prayButton = MoyangButton(.sheepPrimary).then {
        $0.setTitle("기도하기", for: .normal)
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .nightSky4
        layer.cornerRadius = 12
        layer.masksToBounds = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func setupUI() {
        setupDateLabel()
        setupForwardImageView()
        setuptitleLabel()
        setupcontentLabel()
        setuplatestPrayDateLabel()
        setupPrayButton()
        
    }
    private func setupForwardImageView() {
        addSubview(forwardImageView)
        forwardImageView.snp.makeConstraints {
            $0.centerY.equalTo(dateLabel)
            $0.right.equalToSuperview().inset(16)
            $0.width.equalTo(10)
            $0.height.equalTo(16)
        }
    }
    private func setupDateLabel() {
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
        }
    }
    private func setuptitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(56)
            $0.left.equalToSuperview().inset(16)
        }
    }
    private func setupcontentLabel() {
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(88)
            $0.left.equalToSuperview().inset(16)
        }
    }
    private func setuplatestPrayDateLabel() {
        addSubview(latestPrayDateLabel)
        latestPrayDateLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(170)
            $0.left.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    private func setupPrayButton() {
        addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(148)
            $0.right.equalToSuperview().inset(16)
            $0.height.equalTo(36)
            $0.width.equalTo(92)
        }
    }
}

// MARK: - ShowAllView
class ShowAllView: UIView {
    let showAllLabel = MoyangLabel().then {
        $0.text = "모든 기도보기"
        $0.textColor = .sheep2
        $0.font = .b01
    }
    let descLabel = MoyangLabel().then {
        $0.text = "0개의 기도제목이 있어요"
        $0.textColor = .sheep3
        $0.font = .b03
    }
    let forwardImageView = UIImageView(image: UIImage(systemName: "chevron.forward")).then {
        $0.tintColor = .sheep3
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .nightSky4
        layer.cornerRadius = 12
        layer.masksToBounds = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func setupUI() {
        setupShowAllLabel()
        setupDescLabel()
        setupForwardImageView()
    }
    private func setupShowAllLabel() {
        addSubview(showAllLabel)
        showAllLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
        }
    }
    private func setupDescLabel() {
        addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(52)
            $0.left.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
    private func setupForwardImageView() {
        addSubview(forwardImageView)
        forwardImageView.snp.makeConstraints {
            $0.centerY.equalTo(showAllLabel)
            $0.right.equalToSuperview().inset(16)
            $0.width.equalTo(10)
            $0.height.equalTo(16)
        }
    }
}

// MARK: - AddNewPrayView
class AddNewPrayView: UIView {
    let descLabel = MoyangLabel().then {
        $0.text = "주님의 음성을 듣는 방법"
        $0.font = .b03
        $0.textColor = .sheep2
    }
    let writePrayLabel = MoyangLabel().then {
        $0.text = "새 기도 작성하기"
        $0.font = .headline
        $0.textColor = .sheep2
    }
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .nightSky3
        layer.cornerRadius = 12
        layer.masksToBounds = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    private func setupUI() {
        setupDescLabel()
        setupWritePrayLabel()
    }
    private func setupDescLabel() {
        addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(16)
        }
    }
    private func setupWritePrayLabel() {
        addSubview(writePrayLabel)
        writePrayLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(72)
            $0.left.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}
