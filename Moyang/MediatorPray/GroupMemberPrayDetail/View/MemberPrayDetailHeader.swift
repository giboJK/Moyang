//
//  MemberPrayDetailHeader.swift
//  Moyang
//
//  Created by kibo on 2022/11/24.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class MemberPrayDetailHeader: UIView {
    typealias VM = GroupMemberPrayDetailVM
    var disposeBag: DisposeBag?
    var vm: VM?
    
    // MARK: - Property
    var groupList = [String]()
    
    // MARK: - UI
    let infoLabel = MoyangLabel().then {
        $0.text = "기본정보"
        $0.textColor = .wilderness1
        $0.font = .headline
    }
    let categoryLabel = MoyangLabel().then {
        $0.text = "카테고리"
        $0.textColor = .sheep3
        $0.font = .b03
    }
    let categoryTextField = MoyangTextField(.sheep, "카테고리").then {
        $0.returnKeyType = .done
    }
    let groupLabel = MoyangLabel().then {
        $0.text = "중보기도 요청"
        $0.textColor = .sheep3
        $0.font = .b03
    }
    let groupTextField = MoyangTextField(.sheep, "공동체")
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .nightSky1
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        setupInfoLabel()
        setupCategoryLabel()
        setupCategoryTextField()
        setupGroupLabel()
        setupGroupTextField()
    }
    private func setupInfoLabel() {
        addSubview(infoLabel)
        infoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.left.equalToSuperview().inset(24)
            $0.height.equalTo(21)
        }
    }
    private func setupCategoryLabel() {
        addSubview(categoryLabel)
        categoryLabel.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(24)
            $0.height.equalTo(17)
        }
    }
    private func setupCategoryTextField() {
        addSubview(categoryTextField)
        categoryTextField.snp.makeConstraints {
            $0.top.equalTo(categoryLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
    }
    
    private func setupGroupLabel() {
        addSubview(groupLabel)
        groupLabel.snp.makeConstraints {
            $0.top.equalTo(categoryTextField.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupGroupTextField() {
        addSubview(groupTextField)
        groupTextField.snp.makeConstraints {
            $0.top.equalTo(groupLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
    }
    
    func bind() {
//        guard let vm = vm, let disposeBag = disposeBag else { Log.e("No vm"); return }
//        let input = VM.Input(setCategory: categoryTextField.rx.text.asDriver(),
//                             setGroup: groupTextField.rx.text.asDriver())
//        let output = vm.transform(input: input)
//
//        output.category
//            .distinctUntilChanged()
//            .drive(categoryTextField.rx.text)
//            .disposed(by: disposeBag)
//
//        output.groupName
//            .distinctUntilChanged()
//            .drive(groupTextField.rx.text)
//            .disposed(by: disposeBag)
    }
}

