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
            $0.top.equalTo(prayAlarmView.snp.bottom).offset(32)
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
    
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    private func bindViews() {
        prayAlarmView.setupButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.setupNewAlarm()
            }).disposed(by: disposeBag)
        
        qtAlarmView.setupButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.setupNewAlarm()
            }).disposed(by: disposeBag)
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(setNewPray: prayAlarmView.setupButton.rx.tap.asDriver(),
                             setNewQT: qtAlarmView.setupButton.rx.tap.asDriver()
        )
        let output = vm.transform(input: input)
        
        output.prayTime
            .drive(onNext: { [weak self] item in
                self?.prayAlarmView.setTime(data: item?.time, isOn: item?.isOn)
            }).disposed(by: disposeBag)
        
        output.qtTime
            .drive(onNext: { [weak self] item in
                self?.qtAlarmView.setTime(data: item?.time, isOn: item?.isOn)
            }).disposed(by: disposeBag)
    }
}

protocol AlarmSetVCDelegate: AnyObject {
    
}
