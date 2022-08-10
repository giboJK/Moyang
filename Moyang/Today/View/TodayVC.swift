//
//  TodayVC.swift
//  Moyang
//
//  Created by kibo on 2022/08/10.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class TodayVC: UIViewController, VCType {
    typealias VM = TodayVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: TodayVCDelegate?
    
    let scrollView = UIScrollView()
    let container = UIView().then {
        $0.backgroundColor = .clear
    }
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep1
    }
    let newsButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "bell", withConfiguration: config), for: .normal)
        $0.tintColor = .sheep1
    }
    let morningTaskListView = TaskListView()
    let afternoonTaskListView = TaskListView()
    let nightTaskListView = TaskListView()
    
    // MARK: - UI
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
        setupTitleLabel()
        setupNewsButton()
        setupMorningTaskListView()
        setupAfternoonTaskListView()
        setupNightTaskListView()
    }
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        scrollView.addSubview(container)
        container.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.height.equalTo(scrollView.frameLayoutGuide).priority(250)
        }
    }
    private func setupTitleLabel() {
        container.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(28)
            $0.right.equalToSuperview().inset(80)
            $0.top.equalToSuperview().inset(24)
        }
    }
    private func setupNewsButton() {
        container.addSubview(newsButton)
        newsButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(28)
            $0.top.equalToSuperview().inset(24)
            $0.size.equalTo(20)
        }
    }
    private func setupMorningTaskListView() {
        container.addSubview(morningTaskListView)
        morningTaskListView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupAfternoonTaskListView() {
        container.addSubview(afternoonTaskListView)
        afternoonTaskListView.snp.makeConstraints {
            $0.top.equalTo(morningTaskListView.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupNightTaskListView() {
        container.addSubview(nightTaskListView)
        nightTaskListView.snp.makeConstraints {
            $0.top.equalTo(afternoonTaskListView.snp.bottom).offset(32)
            $0.left.right.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().inset(40)
        }
    }

    // MARK: - Binding
    func bind() {
        bindVM()
    }
    private func bineViews() {

    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input()
        let output = vm.transform(input: input)
        
        output.greeting
            .drive(titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.morning
            .drive(morningTaskListView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.afternoon
            .drive(afternoonTaskListView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.night
            .drive(nightTaskListView.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.morningList
            .drive(onNext: { [weak self] list in
                guard let self = self else { return }
                self.morningTaskListView.setItemList(list: list)
            }).disposed(by: disposeBag)

        output.afternoonList
            .drive(onNext: { [weak self] list in
                guard let self = self else { return }
                self.afternoonTaskListView.setItemList(list: list)
            }).disposed(by: disposeBag)

        output.nightList
            .drive(onNext: { [weak self] list in
                guard let self = self else { return }
                self.nightTaskListView.setItemList(list: list)
            }).disposed(by: disposeBag)
    }
}

protocol TodayVCDelegate: AnyObject {

}
