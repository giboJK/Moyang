//
//  PrayDetailHeader.swift
//  Moyang
//
//  Created by kibo on 2022/11/07.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class PrayDetailHeader: UIView {
    typealias VM = MyPrayDetailVM
    var disposeBag: DisposeBag?
    var vm: VM?
    
    // MARK: - Property
    var groupList = [String]()
    
    // MARK: - UI
    let titleLabel = MoyangLabel().then {
        $0.text = "제목"
        $0.textColor = .sheep3
        $0.font = .b03
    }
    let titleTextField = MoyangTextField(.sheep, "제목").then {
        $0.returnKeyType = .done
    }
    let mediatorLabel = MoyangLabel().then {
        $0.text = "중보기도 요청"
        $0.textColor = .sheep3
        $0.font = .b03
    }
    let mediatorTextField = MoyangTextField(.sheep, "공동체")
    let recordButton = MoyangButton(.sheepPrimary).then {
        $0.setTitle("기록하기", for: .normal)
    }
    let changeAndAnswerLabel = MoyangLabel().then {
        $0.text = "변화나 응답이 있나요?"
        $0.textColor = .wilderness1
        $0.font = .b01
    }
    
    var groupDoneButton = UIBarButtonItem()
    var groupCancelButton = UIBarButtonItem()
    let groupToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44)).then {
        $0.sizeToFit()
        $0.clipsToBounds = true
        $0.barTintColor = .sheep2
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
        setupTitleLabel()
        setupTitleTextField()
        setupToolbar()
        setupMediatorLabel()
        setupMediatorTextField()
        setupRecordButton()
        setupChangeAndAnswerLabel()
    }
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(24)
            $0.height.equalTo(17)
        }
    }
    private func setupTitleTextField() {
        addSubview(titleTextField)
        titleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
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
    private func setupMediatorLabel() {
        addSubview(mediatorLabel)
        mediatorLabel.snp.makeConstraints {
            $0.top.equalTo(titleTextField.snp.bottom).offset(24)
            $0.left.equalToSuperview().inset(24)
        }
    }
    private func setupMediatorTextField() {
        addSubview(mediatorTextField)
        mediatorTextField.snp.makeConstraints {
            $0.top.equalTo(mediatorLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        groupPicker.dataSource = self
        groupPicker.delegate = self
        mediatorTextField.inputAccessoryView = groupToolBar
        mediatorTextField.inputView = groupPicker
    }
    private func setupRecordButton() {
        addSubview(recordButton)
        recordButton.snp.makeConstraints {
            $0.width.equalTo(92)
            $0.height.equalTo(36)
            $0.top.equalTo(mediatorTextField.snp.bottom).offset(24)
            $0.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    private func setupChangeAndAnswerLabel() {
        addSubview(changeAndAnswerLabel)
        changeAndAnswerLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(24)
            $0.centerY.equalTo(recordButton)
        }
    }
    
    func bindViews() {
        guard let disposeBag = disposeBag else { return }
        groupDoneButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.mediatorTextField.resignFirstResponder()
                self.mediatorTextField.text = self.groupList[self.groupPicker.selectedRow(inComponent: 0)]
                self.mediatorTextField.sendActions(for: .valueChanged)
            }).disposed(by: disposeBag)
        
        groupCancelButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.mediatorTextField.resignFirstResponder()
            }).disposed(by: disposeBag)
    }
    
    func bind() {
        guard let vm = vm, let disposeBag = disposeBag else { Log.e("No vm"); return }
        let input = VM.Input(addRecord: recordButton.rx.tap.asDriver())
        let output = vm.transform(input: input)
        
        output.title
            .distinctUntilChanged()
            .drive(titleTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.groupName
            .distinctUntilChanged()
            .drive(mediatorTextField.rx.text)
            .disposed(by: disposeBag)
        
        output.groupList.map { list in list.map { $0.name }}
            .drive(onNext: { [weak self] list in
                self?.groupList = list
                self?.groupPicker.reloadAllComponents()
            }).disposed(by: disposeBag)
    }
}


extension PrayDetailHeader: UIPickerViewDelegate, UIPickerViewDataSource {
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
