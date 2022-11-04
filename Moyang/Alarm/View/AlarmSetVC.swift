//
//  AlarmSetVC.swift
//  Moyang
//
//  Created by kibo on 2022/09/14.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import RxGesture

class AlarmSetVC: UIViewController, VCType {
    typealias VM = AlarmSetVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: AlarmSetVCDelegate?
    
    
    // MARK: - UI
    let prayAlarmView = AlarmTimeView(title: "기도")
    let qtAlarmView = AlarmTimeView(title: "말씀 묵상")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
        
    }
    
    deinit { Log.i(self) }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupUI() {
        title = "알람설정"
        view.backgroundColor = .nightSky1
        
        setupPrayAlarmView()
        setupQtAlarmView()
    }
    private func setupPrayAlarmView() {
        view.addSubview(prayAlarmView)
        prayAlarmView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(28)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(120)
        }
    }
    
    private func setupQtAlarmView() {
        view.addSubview(qtAlarmView)
        qtAlarmView.snp.makeConstraints {
            $0.top.equalTo(prayAlarmView.snp.bottom).offset(40)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(120)
        }
    }
    
    private func setupNewAlarm() {
        guard let vm = vm else { return }
        let vc = NewAlarmVC()
        vc.vm = vm
        
        present(vc, animated: true)
    }
    
    private func editAlarm() {
        guard let vm = vm else { return }
        let vc = NewAlarmVC()
        vc.vm = vm
        
        present(vc, animated: true)
    }
    
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let editPray = prayAlarmView.tapBounds.rx.tapGesture().when(.ended).map { _ in () }.asDriver(onErrorJustReturn: ())
        let editQT = qtAlarmView.tapBounds.rx.tapGesture().when(.ended).map { _ in () }.asDriver(onErrorJustReturn: ())
        let input = VM.Input(setNewPray: prayAlarmView.setupButton.rx.tap.asDriver(),
                             setNewQT: qtAlarmView.setupButton.rx.tap.asDriver(),
                             editPray: editPray,
                             editQT: editQT,
                             togglePrayAlarm: prayAlarmView.alarmSwitch.rx.isOn.asDriver(),
                             toggleQtAlarm: qtAlarmView.alarmSwitch.rx.isOn.asDriver()
        )
        let output = vm.transform(input: input)
        
        output.prayTime
            .drive(onNext: { [weak self] item in
                guard let item = item else {
                    self?.prayAlarmView.resetTime()
                    return
                }
                self?.prayAlarmView.setTime(data: item.time, isOn: item.isOn, isSun: item.isSun, isMon: item.isMon,
                                            isTue: item.isTue, isWed: item.isWed, isThu: item.isThu, isFri: item.isFri, isSat: item.isSat)
            }).disposed(by: disposeBag)
        
        output.qtTime
            .drive(onNext: { [weak self] item in
                guard let item = item else {
                    self?.qtAlarmView.resetTime()
                    return
                }
                self?.qtAlarmView.setTime(data: item.time, isOn: item.isOn, isSun: item.isSun, isMon: item.isMon,
                                          isTue: item.isTue, isWed: item.isWed, isThu: item.isThu, isFri: item.isFri, isSat: item.isSat)
            }).disposed(by: disposeBag)
        
        output.setupNewAlarm.skip(1)
            .drive(onNext: { [weak self] _ in
                self?.setupNewAlarm()
            }).disposed(by: disposeBag)
        
        output.editAlarm.skip(1)
            .drive(onNext: { [weak self] _ in
                self?.editAlarm()
            }).disposed(by: disposeBag)
    }
}

protocol AlarmSetVCDelegate: AnyObject {
    
}
