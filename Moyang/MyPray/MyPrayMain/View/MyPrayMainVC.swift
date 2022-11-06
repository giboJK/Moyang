//
//  MyPrayMainVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/10/18.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class MyPrayMainVC: UIViewController, VCType {
    typealias VM = MyPrayMainVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: MyPrayMainVCDelegate?
    
    // MARK: - UI
    let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
    }
    let container = UIView().then {
        $0.backgroundColor = .clear
    }
    let myPraySummaryView = MyPraySummaryView()
    let myPrayHabitView = MyPrayHabitView()

    let indicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }
    
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
        setupScrollView()
        setupMyPraySummaryView()
        setupMyPrayHabitView()
        setupIndicator()
    }
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.equalTo(view.safeAreaLayoutGuide)
            $0.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.addSubview(container)
        container.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide).priority(250)
        }
    }
    private func setupMyPraySummaryView() {
        container.addSubview(myPraySummaryView)
        myPraySummaryView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.left.right.equalToSuperview().inset(24)
        }
        myPraySummaryView.vm = vm
        myPraySummaryView.disposeBag = disposeBag
        myPraySummaryView.bind()
    }
    private func setupMyPrayHabitView() {
        container.addSubview(myPrayHabitView)
        myPrayHabitView.snp.makeConstraints {
            $0.top.equalTo(myPraySummaryView.snp.bottom).offset(48)
            $0.bottom.equalToSuperview().inset(12)
            $0.left.right.equalToSuperview().inset(24)
        }
        myPrayHabitView.vm = vm
        myPrayHabitView.disposeBag = disposeBag
        myPrayHabitView.bind()
    }
    
    private func setupIndicator() {
        view.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.center.equalToSuperview()
        }
    }

    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
        myPraySummaryView.addNewPrayView.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapNewPray()
            }).disposed(by: disposeBag)
        
        myPrayHabitView.myPrayAlarmView.tabBound.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapSetAlarm()
            }).disposed(by: disposeBag)
        myPrayHabitView.myPrayAlarmView.tabBoundTwo.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapSetAlarm()
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input()
        let output = vm.transform(input: input)
        
        output.isNetworking
            .distinctUntilChanged()
            .drive(onNext: { [weak self] isNetworking in
                if isNetworking {
                    self?.indicator.startAnimating()
                } else {
                    self?.indicator.stopAnimating()
                }
            }).disposed(by: disposeBag)
        
        output.detailVM
            .drive(onNext: { [weak self] detailVM in
                guard let detailVM = detailVM else { return }
                self?.coordinator?.didTapPray(vm: detailVM)
            }).disposed(by: disposeBag)
    }
}

protocol MyPrayMainVCDelegate: AnyObject {
    func didTapNewPray()
    func didTapPrayList()
    func didTapPray(vm: MyPrayDetailVM)
    func didTapSetAlarm()
}
