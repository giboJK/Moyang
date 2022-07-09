//
//  GroupPrayListVC.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/02.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import RxGesture

class GroupPrayListVC: UIViewController, VCType {
    typealias VM = GroupPrayListVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupPrayListVCDelegate?
    
    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
    }
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
    let prayButton = UIButton().then {
        $0.setTitle("기도하기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        $0.tintColor = .sheep1
        $0.backgroundColor = .nightSky1
        $0.layer.cornerRadius = 12
        $0.semanticContentAttribute = .forceRightToLeft
    }
    let cellCoverView = UIView().then {
        $0.backgroundColor = .sheep4.withAlphaComponent(0.7)
        $0.isHidden = true
    }
    let reactionView = ReactionPopupView().then {
        $0.isHidden = true
    }
    
    let reactionPopupViewHeight: CGFloat = 36 + 8 + 80
    var selected: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        bind()
        NotificationCenter.default.addObserver(self, selector: #selector(movePrayReactionView),
                                               name: NSNotification.Name("GROUP_PRAY_REACTIONVIEW_MOVE"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showPrayReactionView),
                                               name: NSNotification.Name("GROUP_PRAY_REACTIONVIEW_SHOW"), object: nil)
    }
    
    deinit {
        Log.i(self)
        vm?.clearPrayList()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    func setupUI() {
        setupNavBar()
        setupPrayTableView()
        setupPrayButton()
        setupReactionView()
    }
    private func setupNavBar() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(UIApplication.statusBarHeight + 44)
        }
    }
    private func setupPrayTableView() {
        view.addSubview(prayTableView)
        prayTableView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom).offset(12)
            $0.bottom.equalToSuperview()
            $0.left.right.equalToSuperview().inset(8)
        }
    }
    private func setupPrayButton() {
        view.addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalTo(96)
            $0.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
    }
    private func setupReactionView() {
        view.addSubview(reactionView)
        reactionView.snp.makeConstraints {
            $0.width.equalTo(156)
            $0.height.equalTo(reactionPopupViewHeight)
            $0.right.equalToSuperview().inset(12)
            $0.top.equalToSuperview()
        }
    }
    
    @objc func movePrayReactionView(notification: NSNotification) {
        guard let index = notification.userInfo?["index"] as? Int else {
            Log.e(""); return
        }
        guard let cell = prayTableView.cellForRow(at: IndexPath(row: index, section: 0)) as?
                GroupPrayTableViewCell else { Log.e(""); return }

        selected = index

        let contentOffset = prayTableView.contentOffset
        reactionView.isHidden = true
        cellCoverView.isHidden = true
        let navHeight = navBar.frame.height
        let topInset = min(cell.frame.maxY - contentOffset.y + 4 + navHeight,
                           prayTableView.frame.height - reactionPopupViewHeight + 12 + navHeight)
        reactionView.snp.updateConstraints {
            $0.top.equalToSuperview().inset(topInset)
            $0.width.equalTo(0)
            $0.height.equalTo(0)
        }

        cellCoverView.removeFromSuperview()
        cell.bgView.addSubview(cellCoverView)
        cellCoverView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func showPrayReactionView(notification: NSNotification) {
        reactionView.isHidden = false
        cellCoverView.isHidden = false
        reactionView.snp.updateConstraints {
            $0.width.equalTo(156)
            $0.height.equalTo(reactionPopupViewHeight)
        }
        UIView.animate(withDuration: 0.15) {
            self.view.updateConstraints()
            self.view.layoutIfNeeded()
            self.isAnimating = false
        }
    }
    func showPrayReactionDetailVC(vm: PrayReactionDetailVM) {
        let vc = PrayReactionDetailVC()
        vc.vm = vm
        present(vc, animated: true)
    }
    func showPrayReplyDetailVC(vm: PrayReplyDetailVM) {
        let vc = PrayReplyDetailVC()
        vc.vm = vm
        present(vc, animated: true)
    }

    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
        navBar.backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        bindPrayTableView()
    }
    
    var contentOffset: CGFloat = 0
    var isAnimating = false
    let animationTime = 0.3
    
    private func bindPrayTableView() {
        prayTableView.rx.contentOffset
            .skip(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .asDriver(onErrorJustReturn: CGPoint(x: 0, y: 0))
            .throttle(.milliseconds(300))
            .drive(onNext: { [weak self] offset in
                guard let self = self else { return }
                
                let offset = self.prayTableView.contentOffset.y
                let maxOffset = self.prayTableView.contentSize.height - self.prayTableView.frame.size.height
                if maxOffset - offset <= 0 {
                    self.vm?.fetchMorePrayList()
                }
            }).disposed(by: disposeBag)
        
        prayTableView.rx.willBeginDragging
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.contentOffset = max(self.prayTableView.contentOffset.y, 0)
                self.reactionView.isHidden = true
                self.cellCoverView.removeFromSuperview()
                self.cellCoverView.isHidden = true
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
        
        prayTableView.rx.itemSelected
            .subscribe(onNext: { [weak self] _ in
                self?.reactionView.isHidden = true
                self?.cellCoverView.isHidden = true
                self?.cellCoverView.removeFromSuperview()
            }).disposed(by: disposeBag)
    }
    
    private func moveDownButton() {
        if isAnimating { return }
        isAnimating = true
        prayButton.snp.updateConstraints {
            $0.bottom.equalToSuperview().offset(56)
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
        prayButton.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
        UIView.animate(withDuration: animationTime) {
            self.view.updateConstraints()
            self.view.layoutIfNeeded()
            self.isAnimating = false
        }
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let addComment = reactionView.replyView.rx.tapGesture().when(.ended).map { [weak self] _ in self?.selected }
        let addChange = reactionView.changeView.rx.tapGesture().when(.ended).map { [weak self] _ in self?.selected }
        let input = VM.Input(letsPraying: prayButton.rx.tap.asDriver(),
                             selectPray: prayTableView.rx.itemSelected.asDriver(),
                             addLove: reactionView.loveButton.rx.tap.map { [weak self] _ in self?.selected }.asDriver(onErrorJustReturn: nil),
                             addJoyful: reactionView.joyfulButton.rx.tap.map { [weak self] _ in self?.selected }.asDriver(onErrorJustReturn: nil),
                             addSad: reactionView.sadButton.rx.tap.map { [weak self] _ in self?.selected }.asDriver(onErrorJustReturn: nil),
                             addPray: reactionView.prayButton.rx.tap.map { [weak self] _ in self?.selected }.asDriver(onErrorJustReturn: nil),
                             addComment: addComment.asDriver(onErrorJustReturn: nil),
                             addChange: addChange.asDriver(onErrorJustReturn: nil)
        )
        let output = vm.transform(input: input)
        
        output.name
            .drive(navBar.titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.prayList
            .drive(prayTableView.rx
                .items(cellIdentifier: "cell", cellType: GroupPrayTableViewCell.self)) { (index, item, cell) in
                    cell.index = index
                    cell.setupData(item: item)
                }.disposed(by: disposeBag)

        output.groupPrayingVM
            .drive(onNext: { [weak self] groupPrayingVM in
              guard let groupPrayingVM = groupPrayingVM else { return }
                self?.coordinator?.didTapPraybutton(vm: groupPrayingVM)
            }).disposed(by: disposeBag)

        output.reactionSuccess
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.reactionView.isHidden = true
                self.cellCoverView.removeFromSuperview()
                self.cellCoverView.isHidden = true
            }).disposed(by: disposeBag)

        output.editVM
            .drive(onNext: { [weak self] editVM in
                guard let editVM = editVM else { return }
                self?.showPrayEditVC(editVM: editVM)
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
        
        output.prayWithAndChangeVM
            .drive(onNext: { [weak self] prayWithAndChangeVM in
                guard let prayWithAndChangeVM = prayWithAndChangeVM else { return }
                self?.showPrayWithAndChangeVC(prayWithAndChangeVM: prayWithAndChangeVM)
            }).disposed(by: disposeBag)
        
        output.isMyPrayList
            .drive(onNext: { [weak self] isMyPrayList in
                self?.reactionView.updateActionContainer(isMyPrayList: isMyPrayList)
            }).disposed(by: disposeBag)
    }
    
    private func showPrayEditVC(editVM: GroupPrayEditVM) {
        let vc = GroupPrayEditVC()
        vc.vm = editVM
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showPrayWithAndChangeVC(prayWithAndChangeVM: PrayWithAndChangeVM) {
        let vc = PrayWithAndChangeVC()
        vc.vm = prayWithAndChangeVM
        navigationController?.pushViewController(vc, animated: true)
    }
}

protocol GroupPrayListVCDelegate: AnyObject {
    func didTapPraybutton(vm: GroupPrayingVM)
}
