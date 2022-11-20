//
//  PrayDetailEditView.swift
//  Moyang
//
//  Created by kibo on 2022/11/20.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class PrayDetailEditView: UIView {
    typealias VM = MyPrayDetailVM
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
    var groupDoneButton = UIBarButtonItem()
    var groupCancelButton = UIBarButtonItem()
    let groupToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)).then {
        $0.sizeToFit()
        $0.clipsToBounds = true
        $0.barTintColor = .sheep2
    }
    let groupClearButton = MoyangButton(.none).then {
        $0.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        $0.tintColor = .nightSky2
    }
    let groupPicker = UIPickerView()
    
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
        setupToolbar()
        setupGroupLabel()
        setupGroupTextField()
        setupGroupClearButton()
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
    
    private func setupToolbar() {
        groupDoneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: nil)
        groupCancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: nil)
        let groupSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        groupToolBar.setItems([groupCancelButton, groupSpace, groupDoneButton], animated: false)
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
        groupPicker.dataSource = self
        groupPicker.delegate = self
        groupTextField.inputAccessoryView = groupToolBar
        groupTextField.inputView = groupPicker
    }
    private func setupGroupClearButton() {
        groupTextField.addSubview(groupClearButton)
        groupClearButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(8)
            $0.size.equalTo(28)
        }
    }
    
    func bindViews() {
        guard let disposeBag = disposeBag else { return }
        groupDoneButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.groupTextField.resignFirstResponder()
                self.groupTextField.text = self.groupList[self.groupPicker.selectedRow(inComponent: 0)]
                self.groupTextField.sendActions(for: .valueChanged)
            }).disposed(by: disposeBag)
        
        groupCancelButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.groupTextField.resignFirstResponder()
            }).disposed(by: disposeBag)
        
        groupClearButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.groupTextField.text = nil
                self?.groupTextField.sendActions(for: .valueChanged)
            }).disposed(by: disposeBag)
        
        groupTextField.rx.text.map { $0?.isEmpty ?? true }
            .bind(to: groupClearButton.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func bind() {
        guard let vm = vm, let disposeBag = disposeBag else { Log.e("No vm"); return }
        let input = VM.Input(setCategory: categoryTextField.rx.text.asDriver(),
                             setGroup: groupTextField.rx.text.asDriver())
        let output = vm.transform(input: input)
        
        output.category
            .distinctUntilChanged()
            .drive(categoryTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.groupName
            .distinctUntilChanged()
            .drive(groupTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.groupName.map { $0?.isEmpty ?? true }
            .drive(groupClearButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.groupList.map { list in list.map { $0.name }}
            .drive(onNext: { [weak self] list in
                self?.groupList = list
                self?.groupPicker.reloadAllComponents()
            }).disposed(by: disposeBag)
    }
}


extension PrayDetailEditView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupList.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groupList[row]
    }
}

