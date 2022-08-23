//
//  MoyangSearchBar.swift
//  Moyang
//
//  Created by kibo on 2022/08/23.
//

import UIKit
import SnapKit
import Then

class MoyangSearchBar: UIView {
    let searchImageView = UIImageView().then {
        $0.tintColor = .nightSky2
        $0.image = UIImage(systemName: "magnifyingglass")?.withTintColor(.nightSky2)
    }
    let textField = MoyangTextField(padding: UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)).then {
        $0.backgroundColor = .sheep3
        $0.layer.cornerRadius = 8
        $0.attributedPlaceholder = NSAttributedString(string: "#태그 검색",
                                                      attributes: [.foregroundColor: UIColor.nightSky2])
        $0.textColor = .nightSky1
        $0.returnKeyType = .done
    }
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupSearchImageView()
        setupTextField()
    }
    private func setupSearchImageView() {
        addSubview(searchImageView)
        searchImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
            $0.size.equalTo(28)
        }
    }
    private func setupTextField() {
        addSubview(textField)
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(searchImageView.snp.right).offset(12)
            $0.right.equalToSuperview()
        }
        let keyboardToolbar = UIToolbar()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let donButton = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(didTapDone))
        keyboardToolbar.items = [space, donButton]
        keyboardToolbar.sizeToFit()

        textField.inputAccessoryView = keyboardToolbar
    }
    
    @objc func didTapDone() {
        textField.endEditing(true)
    }
}
