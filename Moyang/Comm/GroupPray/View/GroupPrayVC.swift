//
//  GroupPrayVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/01.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupPrayVC: UIViewController, VCType {
    typealias VM = GroupPrayVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupPrayVCDelegate?
    
    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
    }
    let infoButton = UIButton().then {
        $0.setTitle("정보", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        $0.setTitleColor(.nightSky1, for: .normal)
    }
    let groupPrayCalendar = GroupPrayCalendar()
    let prayTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(GroupPrayTableViewCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .sheep1
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 220
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    let addPrayButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .large)
        $0.setTitle("새 기도 ", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        $0.tintColor = .sheep1
        $0.backgroundColor = .nightSky1
        $0.layer.cornerRadius = 12
        $0.semanticContentAttribute = .forceRightToLeft
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
    }
    
    deinit { Log.i(self) }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupUI() {
        view.backgroundColor = .sheep1
        setupNavBar()
        setupInfoButton()
        setupPrayTableView()
        setupAddPrayButton()
    }
    
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIApplication.statusBarHeight + 44)
        }
    }
    
    private func setupInfoButton() {
        navBar.addSubview(infoButton)
        infoButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(20)
            $0.width.equalTo(32)
        }
    }
    private func setupPrayTableView() {
        view.addSubview(prayTableView)
        prayTableView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        prayTableView.stickyHeader.view = groupPrayCalendar
        prayTableView.stickyHeader.height = 232 + 60
        prayTableView.stickyHeader.minimumHeight = 60
    }
    private func setupAddPrayButton() {
        view.addSubview(addPrayButton)
        addPrayButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(96)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
    }
    
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    var contentOffset: CGFloat = 0
    var isAnimating = false
    let animationTime = 0.3
    
    private func bindPrayTableView() {
        prayTableView.rx.willBeginDragging
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.contentOffset = max(self.prayTableView.contentOffset.y, 0)
            }).disposed(by: disposeBag)
        
        prayTableView.rx.didScroll
            .debounce(.milliseconds(10), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                if self.isAnimating { return }
                if self.contentOffset - self.prayTableView.contentOffset.y > 30 {
                    self.moveUpButton()
                } else if self.prayTableView.contentOffset.y - self.contentOffset > 30 {
                    self.moveDownButton()
                }
            }).disposed(by: disposeBag)
    }
    private func moveDownButton() {
        if isAnimating { return }
        isAnimating = true
        addPrayButton.snp.remakeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(96)
            $0.bottom.equalToSuperview().offset(56)
            $0.centerX.equalToSuperview()
        }
        UIView.animate(withDuration: animationTime) {
            self.view.updateConstraints()
            self.view.layoutIfNeeded()
            self.isAnimating = false
        }
    }
    
    private func moveUpButton() {
        if isAnimating { return }
        isAnimating = true
        addPrayButton.snp.remakeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(96)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.centerX.equalToSuperview()
        }
        UIView.animate(withDuration: animationTime) {
            self.view.updateConstraints()
            self.view.layoutIfNeeded()
            self.isAnimating = false
        }
    }
    
    func showPrayReactionDetailVC(vm: PrayReactionDetailVM) {
        if navigationController?.topViewController is GroupPrayVC {
            let vc = PrayReactionDetailVC()
            vc.vm = vm
            present(vc, animated: true)
        }
    }
    
    func showPrayReplyDetailVC(vm: PrayReplyDetailVM) {
        if navigationController?.topViewController is GroupPrayVC {
            let vc = PrayReplyDetailVC()
            vc.vm = vm
            present(vc, animated: true)
        }
    }
    
    private func bindViews() {
        navBar.backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        infoButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.didTapInfoButton()
            }).disposed(by: disposeBag)
        
        addPrayButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.coordinator?.didTapNewPrayButton(vm: self.vm)
            }).disposed(by: disposeBag)
        
        bindPrayTableView()
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(selectMember: prayTableView.rx.itemSelected.asDriver(),
                             releaseDetailVM: self.rx.viewWillAppear.map { _ in () }.asDriver(onErrorJustReturn: ()))
        let output = vm.transform(input: input)
        
        output.groupName
            .drive(navBar.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.cardPrayItemList
            .drive(prayTableView.rx
                .items(cellIdentifier: "cell", cellType: GroupPrayTableViewCell.self)) { (index, item, cell) in
                    cell.index = index
                    cell.setupData(item: item, isPreview: true)
                }.disposed(by: disposeBag)
        
        output.detailVM
            .drive(onNext: { [weak self] detailVM in
                guard let detailVM = detailVM else { return }
                self?.coordinator?.didTapPray(vm: detailVM)
            }).disposed(by: disposeBag)
        
        output.addingNewPraySuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showTopToast(type: .success, message: "기도 추가 완료", disposeBag: self.disposeBag)
            }).disposed(by: disposeBag)
        
        output.addingNewPrayFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showTopToast(type: .failure, message: "기도 추가 중 문제가 발생하였습니다.", disposeBag: self.disposeBag)
            }).disposed(by: disposeBag)
        
        output.prayReactionDetailVM
            .drive(onNext: { [weak self] prayReactionDetailVM in
                guard let prayReactionDetailVM = prayReactionDetailVM else { return }
                self?.showPrayReactionDetailVC(vm: prayReactionDetailVM)
            }).disposed(by: disposeBag)
        
        output.prayReplyDetailVM
            .drive(onNext: { [weak self] prayReplyDetailVM in
                guard let prayReplyDetailVM = prayReplyDetailVM else { return }
                self?.showPrayReplyDetailVC(vm: prayReplyDetailVM)
            }).disposed(by: disposeBag)
    }
}

protocol GroupPrayVCDelegate: AnyObject {
    func didTapInfoButton()
    func didTapNewPrayButton(vm: GroupPrayVM?)
    func didTapPray(vm: GroupPrayListVM)
}
