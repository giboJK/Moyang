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
    let typeContainer = UIView()
    let typeLabel = MoyangLabel().then {
        $0.text = "변화"
        $0.textColor = .nightSky2
        $0.font = .b03
    }
    let downImageView = UIImageView(image: UIImage(systemName: "arrowtriangle.down.fill")).then {
        $0.tintColor = .nightSky2
    }
//    let prayButton = MoyangButton(.nightPrimary).then {
//        $0.setTitle("기도하기", for: .normal)
//    }
    let textView = ChangeAnswerTextView("기도에 변화와 응답이 있나요?")
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .sheep2
        setupUI()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
//                                               name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
//                                               name: UIResponder.keyboardWillHideNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardObserverSet),
//                                               name: NSNotification.Name.MyPrayDetailVCKeyboard, object: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
//        hidePrayButton()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
//        if textView.textView.text.isEmpty {
//            showPrayButton()
//        }
    }
    
    @objc func keyboardObserverSet(notification: NSNotification) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    private func setupUI() {
        setupTextView()
//        setupPrayButton()
        setupTypeContainer()
    }
    private func setupTextView() {
        addSubview(textView)
        textView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(55)
            $0.top.equalToSuperview().inset(4)
            $0.right.equalToSuperview().inset(12)
            $0.height.greaterThanOrEqualTo(36)
            $0.bottom.equalToSuperview().inset(UIApplication.bottomInset + 4)
        }
    }
//    private func setupPrayButton() {
//        addSubview(prayButton)
//        prayButton.snp.makeConstraints {
//            $0.width.equalTo(100)
//            $0.height.equalTo(36)
//            $0.bottom.equalTo(textView)
//            $0.right.equalToSuperview().inset(12)
//        }
//    }
    private func setupTypeContainer() {
        addSubview(typeContainer)
        typeContainer.snp.makeConstraints {
            $0.left.equalToSuperview().inset(12)
            $0.bottom.equalTo(textView).inset(10)
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
    
//    private func hidePrayButton() {
//        textView.snp.updateConstraints {
//            $0.right.equalToSuperview().inset(12)
//        }
//        prayButton.isHidden = true
//        UIView.animate(withDuration: 0.5) {
//            self.updateConstraints()
//            self.layoutIfNeeded()
//        }
//    }
//
//    private func showPrayButton() {
//        textView.snp.updateConstraints {
//            $0.right.equalToSuperview().inset(120)
//        }
//        prayButton.isHidden = false
//        UIView.animate(withDuration: 0.5) {
//            self.updateConstraints()
//            self.layoutIfNeeded()
//        }
//    }
}

class ChangeAnswerTextView: UIView {
    let textView = MoyangTextView(.sheep, padding: UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 36))
    let placeholder = MoyangLabel().then {
        $0.font = .b03
        $0.textColor = .sheep3
    }
    let saveImageView = UIImageView(image: UIImage(systemName: "arrow.up.circle.fill")).then {
        $0.tintColor = .nightSky2
    }
    
    init(_ placeholder: String) {
        super.init(frame: .zero)
        backgroundColor = .clear
        self.placeholder.text = placeholder
        setupUI()
        textViewDidChange(textView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupTextView()
        setupPlaceholder()
        setupSaveImageView()
    }
    private func setupTextView() {
        addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.height.equalTo(36)
            $0.bottom.equalToSuperview()
        }
        textView.delegate = self
    }
    private func setupPlaceholder() {
        addSubview(placeholder)
        placeholder.snp.makeConstraints {
            $0.top.equalTo(textView).inset(9)
            $0.left.equalTo(textView).inset(8)
        }
    }
    private func setupSaveImageView() {
        addSubview(saveImageView)
        saveImageView.snp.makeConstraints {
            $0.size.equalTo(32)
            $0.bottom.equalTo(textView).inset(2)
            $0.right.equalTo(textView).inset(2)
        }
    }
}

extension ChangeAnswerTextView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholder.isHidden = !textView.text.isEmpty
        saveImageView.isHidden = textView.text.isEmpty
        textView.snp.updateConstraints {
            $0.height.equalTo(min(16 + 17*4, max(36, textView.numberOfLines() * 17 + 16)))
        }
    }
}
