//
//  GroupMemberPrayBottomView.swift
//  Moyang
//
//  Created by kibo on 2022/11/24.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit


class GroupMemberPrayBottomView: UIView {
    let typeContainer = UIView()
    let typeLabel = MoyangLabel().then {
        $0.text = "기도 더하기"
        $0.textColor = .nightSky2
        $0.font = .b03
    }
    let downImageView = UIImageView(image: UIImage(systemName: "arrowtriangle.down.fill")).then {
        $0.tintColor = .nightSky2
    }
    let prayButton = MoyangButton(.nightPrimary).then {
        $0.setTitle("기도하기", for: .normal)
    }
    let textView = ChangeAnswerTextView("같이 기도해보세요 :)")
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .sheep2
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        hidePrayButton()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if textView.textView.text.isEmpty {
            showPrayButton()
        }
    }
    
    private func setupUI() {
        setupTextView()
        setupPrayButton()
        setupTypeContainer()
    }
    private func setupTextView() {
        addSubview(textView)
        textView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(92)
            $0.top.equalToSuperview().inset(4)
            $0.right.equalToSuperview().inset(120)
            $0.height.greaterThanOrEqualTo(36)
            $0.bottom.equalToSuperview().inset(UIApplication.bottomInset + 4)
        }
    }
    private func setupPrayButton() {
        addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.width.equalTo(100)
            $0.height.equalTo(36)
            $0.bottom.equalTo(textView)
            $0.right.equalToSuperview().inset(12)
        }
    }
    private func setupTypeContainer() {
        addSubview(typeContainer)
        typeContainer.snp.makeConstraints {
            $0.left.equalToSuperview().inset(12)
            $0.centerY.equalTo(prayButton)
            $0.height.equalTo(17)
        }
        setupTypeLabel()
        setupDownImageView()
    }
    private func setupTypeLabel() {
        typeContainer.addSubview(typeLabel)
        typeLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview()
        }
    }
    private func setupDownImageView() {
        typeContainer.addSubview(downImageView)
        downImageView.snp.makeConstraints {
            $0.left.equalTo(typeLabel.snp.right).offset(4)
            $0.centerY.right.equalToSuperview()
            $0.size.equalTo(8)
        }
    }
    
    private func hidePrayButton() {
        textView.snp.updateConstraints {
            $0.right.equalToSuperview().inset(12)
        }
        prayButton.isHidden = true
        UIView.animate(withDuration: 0.5) {
            self.updateConstraints()
            self.layoutIfNeeded()
        }
    }
    
    private func showPrayButton() {
        textView.snp.updateConstraints {
            $0.right.equalToSuperview().inset(120)
        }
        prayButton.isHidden = false
        UIView.animate(withDuration: 0.5) {
            self.updateConstraints()
            self.layoutIfNeeded()
        }
    }
}
