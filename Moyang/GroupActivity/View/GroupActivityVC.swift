//
//  GroupActivityVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/01.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupActivityVC: UIViewController, VCType {
    typealias VM = GroupActivityVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupActivityVCDelegate?
    var groupCreateDate: Date!
    
    // MARK: - UI
    let newsButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "bell", withConfiguration: config), for: .normal)
        $0.tintColor = .sheep1
    }
    let addButton = UIButton().then {
        $0.setImage(Asset.Images.Pray.addItem.image.withTintColor(.sheep1), for: .normal)
        $0.tintColor = .sheep1
    }
    let greetingLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .semibold)
        $0.textColor = .sheep2
        $0.numberOfLines = 2
    }
    let tabView = GroupActivityTabView()
    let groupPrayView = GroupPrayView()
    let groupQTView = GroupQTView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
        self.hidesBottomBarWhenPushed = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    deinit { Log.i(self) }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupUI() {
        view.backgroundColor = .nightSky1
        
        setupNewsButton()
        setupAddButton()
        setupGreetingLabel()
        setupTabView()
        
        setupGroupPrayView()
        setupGroupQTView()
    }
    private func setupNewsButton() {
        view.addSubview(newsButton)
        newsButton.snp.makeConstraints {
            $0.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.size.equalTo(24)
        }
    }
    private func setupAddButton() {
        view.addSubview(addButton)
        addButton.snp.makeConstraints {
            $0.right.equalTo(newsButton.snp.left).offset(-16)
            $0.top.equalTo(newsButton)
            $0.size.equalTo(24)
        }
    }
    private func setupGreetingLabel() {
        view.addSubview(greetingLabel)
        greetingLabel.snp.makeConstraints {
            $0.top.equalTo(newsButton)
            $0.left.equalToSuperview().inset(17)
            $0.right.equalTo(addButton.snp.left).offset(-8)
        }
    }
    private func setupTabView() {
        view.addSubview(tabView)
        tabView.snp.makeConstraints {
            $0.top.equalTo(greetingLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
    
    private func setupGroupPrayView() {
        view.addSubview(groupPrayView)
        groupPrayView.snp.makeConstraints {
            $0.top.equalTo(tabView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        groupPrayView.vm = vm
        groupPrayView.bind()
//        groupPrayView.moreButtonHandler = showAddOptions
    }
    private func setupGroupQTView() {
        view.addSubview(groupQTView)
        groupQTView.snp.makeConstraints {
            $0.top.equalTo(tabView.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
        groupQTView.isHidden = true
        groupQTView.vm = vm
        groupQTView.bind()
    }
    
    private func showAddOptions() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "새 기도", style: .default , handler: { [weak self] _ in
            guard let vm = self?.vm else { return }
            self?.coordinator?.didTapNewPrayButton(vm: vm)
        }))
        alert.addAction(UIAlertAction(title: "새 묵상", style: .default , handler: { [weak self] _ in
            guard let vm = self?.vm else { return }
            self?.coordinator?.didTapNewQTButton(vm: vm)
        }))
        
        alert.addAction(UIAlertAction(title: "한 줄 감사", style: .default , handler: { _ in
        }))
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
        }))

//        uncomment for iPad Support
        alert.popoverPresentationController?.sourceView = self.view

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
        newsButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapNewsButton()
            }).disposed(by: disposeBag)
        
        addButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.showAddOptions()
            }).disposed(by: disposeBag)
        
        tabView.menuCV.rx.itemSelected
            .skip(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] index in
                switch index.row {
                case 0:
                    self?.groupPrayView.isHidden = false
                    self?.groupQTView.isHidden = true
                case 1:
                    self?.groupPrayView.isHidden = true
                    self?.groupQTView.isHidden = false
                default:
                    self?.groupPrayView.isHidden = true
                    self?.groupQTView.isHidden = true
                }
            }).disposed(by: disposeBag)
    }
    private func showReactionView(prayReactionDetailVM: PrayReactionDetailVM) {
        let vc = PrayReactionDetailVC()
        vc.vm = prayReactionDetailVM
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(nav, animated: true, completion: nil)
    }
    private func showReplyView(prayReplyDetailVM: PrayReplyDetailVM) {
        let vc = PrayReplyDetailVC()
        vc.vm = prayReplyDetailVM
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(nav, animated: true, completion: nil)
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input()
        
        let output = vm.transform(input: input)
        
        output.greeting
            .drive(greetingLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.groupPrayDetailVM
            .drive(onNext: { [weak self] groupPrayDetailVM in
                guard let groupPrayDetailVM = groupPrayDetailVM else { return }
                self?.coordinator?.didTapPray(vm: groupPrayDetailVM)
            }).disposed(by: disposeBag)
        output.prayReactionDetailVM
            .drive(onNext: { [weak self] prayReactionDetailVM in
                guard let prayReactionDetailVM = prayReactionDetailVM else { return }
                self?.showReactionView(prayReactionDetailVM: prayReactionDetailVM)
            }).disposed(by: disposeBag)
        
        output.prayReplyDetailVM
            .drive(onNext: { [weak self] prayReplyDetailVM in
                guard let prayReplyDetailVM = prayReplyDetailVM else { return }
                self?.showReplyView(prayReplyDetailVM: prayReplyDetailVM)
            }).disposed(by: disposeBag)
        
        output.addingNewPraySuccess.skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showTopToast(type: .success, message: "기도 추가 완료", disposeBag: self.disposeBag)
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        output.addingNewPrayFailure.skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showTopToast(type: .failure, message: "기도 추가 중 문제가 발생하였습니다.", disposeBag: self.disposeBag)
                self.dismiss(animated: true)
            }).disposed(by: disposeBag)
        
        output.bibleSelectVM
            .drive(onNext: { [weak self] bibleSelectVM in
                guard let bibleSelectVM = bibleSelectVM else { return }
                self?.openBibleSelectVC(bibleSelectVM: bibleSelectVM)
            }).disposed(by: disposeBag)
    }
    
    private func openBibleSelectVC(bibleSelectVM: BibleSelectVM) {
        let vc = BibleSelectVC()
        vc.vm = bibleSelectVM
        present(vc, animated: true)
    }
}

protocol GroupActivityVCDelegate: AnyObject {
    func didTapNewsButton()
    func didTapNewPrayButton(vm: GroupActivityVM)
    func didTapNewQTButton(vm: GroupActivityVM)
    func didTapPrayButton(vm: GroupActivityVM)
    func didTapPray(vm: GroupPrayDetailVM)
}
