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
import RxGesture

class NewAlarmVC: UIViewController, VCType {
    typealias VM = AlarmSetVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: NewAlarmVCDelegate?

    // MARK: - UI
    let titleLabel = UILabel().then {
        $0.textColor = .sheep1
        $0.font = .headline
    }
    let saveButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.setTitleColor(.wilderness1, for: .normal)
        $0.titleLabel?.font = .b01
    }
    let deleteButton = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(.appleRed1, for: .normal)
        $0.titleLabel?.font = .b01
        $0.isHidden = true
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
        $0.layer.masksToBounds = true
    }
    let sundayView = AlarmSelectDayView(day: "일요일마다")
    let mondayView = AlarmSelectDayView(day: "월요일마다")
    let tuesdayView = AlarmSelectDayView(day: "화요일마다")
    let wednesdayView = AlarmSelectDayView(day: "수요일마다")
    let thursdayView = AlarmSelectDayView(day: "목요일마다")
    let fridayView = AlarmSelectDayView(day: "금요일마다")
    let saturadayView = AlarmSelectDayView(day: "토요일마다")
    
    
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
        setupDeleteButton()
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
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalTo(titleLabel)
        }
    }
    private func setupDeleteButton() {
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalTo(titleLabel)
        }
    }
    private func setupTimePicker() {
        view.addSubview(timePicker)
        timePicker.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(180)
        }
    }
    private func setupOptionView() {
        view.addSubview(optionView)
        optionView.snp.makeConstraints {
            $0.top.equalTo(timePicker.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(12)
        }
        setupSundayView()
        setupMondayView()
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
            $0.top.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
    private func setupMondayView() {
        optionView.addSubview(mondayView)
        mondayView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
            $0.top.equalTo(sundayView.snp.bottom)
        }
    }
    private func setupTuesdayView() {
        optionView.addSubview(tuesdayView)
        tuesdayView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
            $0.top.equalTo(mondayView.snp.bottom)
        }
    }
    private func setupWednesdayView() {
        optionView.addSubview(wednesdayView)
        wednesdayView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
            $0.top.equalTo(tuesdayView.snp.bottom)
        }
    }
    private func setupThursdayView() {
        optionView.addSubview(thursdayView)
        thursdayView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
            $0.top.equalTo(wednesdayView.snp.bottom)
        }
    }
    private func setupFridayView() {
        optionView.addSubview(fridayView)
        fridayView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
            $0.top.equalTo(thursdayView.snp.bottom)
        }
    }
    private func setupSaturadayView() {
        optionView.addSubview(saturadayView)
        saturadayView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
            $0.top.equalTo(fridayView.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        saturadayView.divider.isHidden = true
    }
    

    // MARK: - Binding
    func bind() {
        bindVM()
    }
    private func bindViews() {

    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let sunGesture = sundayView.rx.tapGesture().when(.ended).map { _ in () }.asDriver(onErrorJustReturn: ())
        let monGesture = mondayView.rx.tapGesture().when(.ended).map { _ in () }.asDriver(onErrorJustReturn: ())
        let tueGesture = tuesdayView.rx.tapGesture().when(.ended).map { _ in () }.asDriver(onErrorJustReturn: ())
        let wedGesture = wednesdayView.rx.tapGesture().when(.ended).map { _ in () }.asDriver(onErrorJustReturn: ())
        let thuGesture = thursdayView.rx.tapGesture().when(.ended).map { _ in () }.asDriver(onErrorJustReturn: ())
        let friGesture = fridayView.rx.tapGesture().when(.ended).map { _ in () }.asDriver(onErrorJustReturn: ())
        let satGesture = saturadayView.rx.tapGesture().when(.ended).map { _ in () }.asDriver(onErrorJustReturn: ())
        let resetEditing = self.rx.viewDidDisappear.map { _ -> Void in () }.asDriver(onErrorJustReturn: ())
        
        let input = VM.Input(save: saveButton.rx.tap.asDriver(),
                             delete: deleteButton.rx.tap.asDriver(),
                             setTime: timePicker.rx.date.asDriver(),
                             toggleSun: sunGesture,
                             toggleMon: monGesture,
                             toggleTue: tueGesture,
                             toggleWed: wedGesture,
                             toggleThu: thuGesture,
                             toggleFri: friGesture,
                             toggleSat: satGesture,
                             resetEditing: resetEditing
        )
        let output = vm.transform(input: input)
        
        output.prayTime
            .drive(onNext: { [weak self] alarmTime in
                guard let self = self, let alarmTime = alarmTime else { return }
                self.timePicker.setDate(from: alarmTime.time, format: "HH:mm")
                self.timePicker.sendActions(for: .editingDidEnd)
            }).disposed(by: disposeBag)
        
        output.newAlarmTitle
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.isEditing.map { !$0 }
            .drive(deleteButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.isSun.map { !$0 }
            .drive(sundayView.chcekmarkImageView.rx.isHidden)
            .disposed(by: disposeBag)
        output.isMon.map { !$0 }
            .drive(mondayView.chcekmarkImageView.rx.isHidden)
            .disposed(by: disposeBag)
        output.isTue.map { !$0 }
            .drive(tuesdayView.chcekmarkImageView.rx.isHidden)
            .disposed(by: disposeBag)
        output.isWed.map { !$0 }
            .drive(wednesdayView.chcekmarkImageView.rx.isHidden)
            .disposed(by: disposeBag)
        output.isThu.map { !$0 }
            .drive(thursdayView.chcekmarkImageView.rx.isHidden)
            .disposed(by: disposeBag)
        output.isFri.map { !$0 }
            .drive(fridayView.chcekmarkImageView.rx.isHidden)
            .disposed(by: disposeBag)
        output.isSat.map { !$0 }
            .drive(saturadayView.chcekmarkImageView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.addingSuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        output.addingFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            }).disposed(by: disposeBag)
    }
}

protocol NewAlarmVCDelegate: AnyObject {

}
