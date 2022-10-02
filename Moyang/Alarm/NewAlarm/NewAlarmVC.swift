//
//  NewAlarmVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/02.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class NewAlarmVC: UIViewController, VCType {
    typealias VM = AlarmSetVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: NewAlarmVCDelegate?

    // MARK: - UI
    let titleLabel = UILabel().then {
        $0.textColor = .sheep1
        $0.font = .systemFont(ofSize: 18, weight: .regular)
    }
    let saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(.wilderness1, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
    }
    private let timePicker: UIDatePicker = {
        let datePicker = UIDatePicker(frame: .zero)
        datePicker.datePickerMode = .time
        datePicker.timeZone = TimeZone.current
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    let optionView = UIView().then {
        $0.layer.cornerRadius = 12
        $0.backgroundColor = .nightSky2.withAlphaComponent(0.8)
    }
    let sundayView = AlarmSelectDayView(day: "일")
    let monView = AlarmSelectDayView(day: "월")
    let tuesdayView = AlarmSelectDayView(day: "화")
    let wednesdayView = AlarmSelectDayView(day: "수")
    let thursdayView = AlarmSelectDayView(day: "목")
    let fridayView = AlarmSelectDayView(day: "금")
    let saturadayView = AlarmSelectDayView(day: "토")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }

    deinit { Log.i(self) }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    func setupUI() {
        view.backgroundColor = .nightSky1
        setupTitleLabel()
        setupSaveButton()
        setupTimePicker()
        setupOptionView()
    }
    
    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.centerX.equalToSuperview()
        }
    }
    
    private func setupSaveButton() {
        view.addSubview(saveButton)
        saveButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(12)
            $0.centerY.equalTo(titleLabel)
        }
    }
    private func setupTimePicker() {
        view.addSubview(timePicker)
        timePicker.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(200)
        }
    }
    private func setupOptionView() {
        view.addSubview(optionView)
        optionView.snp.makeConstraints {
            $0.top.equalTo(timePicker.snp.bottom).offset(12)
            $0.left.right.equalToSuperview().inset(12)
        }
        setupSundayView()
        setupMonView()
        setupTuesdayView()
        setupWednesdayView()
        setupThursdayView()
        setupFridayView()
        setupSaturadayView()
    }
    private func setupSundayView() {
        optionView.addSubview(sundayView)
        sundayView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
    }
    private func setupMonView() {
        optionView.addSubview(monView)
        monView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
    }
    private func setupTuesdayView() {
        optionView.addSubview(tuesdayView)
        tuesdayView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
    }
    private func setupWednesdayView() {
        optionView.addSubview(wednesdayView)
        wednesdayView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
    }
    private func setupThursdayView() {
        optionView.addSubview(thursdayView)
        thursdayView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
    }
    private func setupFridayView() {
        optionView.addSubview(fridayView)
        fridayView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
    }
    private func setupSaturadayView() {
        optionView.addSubview(saturadayView)
        saturadayView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
        }
    }
    

    // MARK: - Binding
    func bind() {
        bindVM()
    }
    private func bindViews() {

    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(save: saveButton.rx.tap.asDriver())
        let output = vm.transform(input: input)
        
        output.newAlarmTitle
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

protocol NewAlarmVCDelegate: AnyObject {

}
