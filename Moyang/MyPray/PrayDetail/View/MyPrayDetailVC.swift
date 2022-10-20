//
//  MyPrayDetailVC.swift
//  Moyang
//
//  Created by kibo on 2022/08/04.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then
import RxGesture

class MyPrayDetailVC: UIViewController, VCType {
    typealias VM = MyPrayDetailVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupPrayDetailVCDelegate?

    // MARK: - UI
    let updateButton = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)
    let prayButton = MoyangButton(.none).then {
        $0.layer.cornerRadius = 8
        $0.tintColor = .sheep1
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 14, weight: .regular)
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .mini
        configuration.attributedTitle = AttributedString("기도하기", attributes: container)
        configuration.baseBackgroundColor = .nightSky4
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        $0.configuration = configuration
    }
    let moreButton = MoyangButton(.none).then {
        $0.layer.cornerRadius = 8
        $0.tintColor = .sheep1
        $0.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        $0.backgroundColor = .clear
    }
    let prayPlusButton = MoyangButton(.none).then {
        $0.layer.cornerRadius = 8
        $0.tintColor = .sheep1
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 14, weight: .regular)
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .mini
        configuration.attributedTitle = AttributedString("기도 더하기", attributes: container)
        configuration.image = UIImage(systemName: "plus")
        configuration.imagePadding = 4
        configuration.baseBackgroundColor = .nightSky4
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        $0.configuration = configuration
    }
    let prayDetailView = PrayDetailView()
    let addChangeButton = MoyangButton(.none).then {
        $0.layer.cornerRadius = 8
        $0.tintColor = .sheep1
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 14, weight: .regular)
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .mini
        configuration.attributedTitle = AttributedString("변화", attributes: container)
        configuration.image = UIImage(systemName: "plus")
        configuration.imagePadding = 4
        configuration.baseBackgroundColor = .nightSky4
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        $0.configuration = configuration
    }
    let addAnswerButton = MoyangButton(.none).then {
        $0.layer.cornerRadius = 8
        $0.tintColor = .sheep1
        var container = AttributeContainer()
        container.font = .systemFont(ofSize: 14, weight: .regular)
        var configuration = UIButton.Configuration.filled()
        configuration.buttonSize = .mini
        configuration.attributedTitle = AttributedString("응답", attributes: container)
        configuration.image = UIImage(systemName: "plus")
        configuration.imagePadding = 4
        configuration.baseBackgroundColor = .nightSky4
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        $0.configuration = configuration
    }
    let prayChangeAndAnswerLabel = UILabel().then {
        $0.text = "기도 변화 / 응답"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .sheep2
    }
    let deleteConfirmPopup = MoyangPopupView(style: .twoButton, firstButtonStyle: .warning, secondButtonStyle: .ghost).then {
        $0.desc = "정말로 삭제하시겠어요? 삭제한 기도는 복구할 수 없습니다."
        $0.firstButton.setTitle("삭제", for: .normal)
        $0.secondButton.setTitle("취소", for: .normal)
    }
    let reactionBgView = UIView().then {
        $0.isHidden = true
    }
    let reactionPopupView = ReactionPopupView().then {
        $0.isHidden = true
    }
    let reactionPopupViewHeight: CGFloat = 36 + 8 + 40
    var isPopupAnimating = false
    var isMyPray = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
    }
    
    // 기도하기 화면 후 복귀 시 필요
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    deinit {
        Log.i(self)
        vm?.deinitVMs()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    func setupUI() {
        title = "기도제목"
        view.backgroundColor = .nightSky1
        setupUpdateButton()
        setupPrayButton()
        setupPrayPlusButton()
        setupAddChangeButton()
        setupAddAnswerButton()
        setupMoreButton()
        setupPrayDetailView()
        setupPrayChangeAndAnswerLabel()
        setupReactionView()
    }
    private func setupUpdateButton() {
        navigationItem.rightBarButtonItem = updateButton
    }
    private func setupPrayButton() {
        view.addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(36)
            $0.left.equalToSuperview().inset(17)
        }
    }
    private func setupPrayPlusButton() {
        view.addSubview(prayPlusButton)
        prayPlusButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(36)
            $0.left.equalTo(prayButton.snp.right).offset(12)
        }
    }
    private func setupAddChangeButton() {
        view.addSubview(addChangeButton)
        addChangeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(36)
            $0.left.equalTo(prayButton.snp.right).offset(12)
        }
    }
    private func setupAddAnswerButton() {
        view.addSubview(addAnswerButton)
        addAnswerButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(36)
            $0.left.equalTo(addChangeButton.snp.right).offset(12)
        }
    }
    private func setupMoreButton() {
        view.addSubview(moreButton)
        moreButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.height.equalTo(36)
            $0.right.equalToSuperview().inset(16)
        }
    }
    private func setupPrayDetailView() {
        view.addSubview(prayDetailView)
        prayDetailView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(52)
            $0.left.right.equalToSuperview()
        }
        prayDetailView.vm = vm
        prayDetailView.bind()
    }
    private func setupPrayChangeAndAnswerLabel() {
        view.addSubview(prayChangeAndAnswerLabel)
        prayChangeAndAnswerLabel.snp.makeConstraints {
            $0.top.equalTo(prayDetailView.snp.bottom).offset(16)
            $0.left.equalToSuperview().inset(20)
        }
    }
    private func setupReactionView() {
        view.addSubview(reactionBgView)
        reactionBgView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        view.addSubview(reactionPopupView)
        reactionPopupView.snp.makeConstraints {
            $0.width.equalTo(0)
            $0.height.equalTo(0)
            $0.right.equalTo(prayDetailView).inset(16)
            $0.top.equalTo(prayDetailView).inset(280)
        }
        reactionPopupView.delegate = self
    }
    func showPrayReactionPopupView() {
        if isMyPray || isPopupAnimating {
            return
        }
        isPopupAnimating = true
        reactionBgView.isHidden = false
        reactionPopupView.isHidden = false
        reactionPopupView.snp.updateConstraints {
            $0.width.equalTo(156)
            $0.height.equalTo(reactionPopupViewHeight)
        }
        UIView.animate(withDuration: 0.15) {
            self.view.updateConstraints()
            self.view.layoutIfNeeded()
            self.isPopupAnimating = false
        }
    }
    func hidePrayReactionPopupView() {
        isPopupAnimating = false
        reactionBgView.isHidden = true
        reactionPopupView.isHidden = true
        reactionPopupView.snp.updateConstraints {
            $0.width.equalTo(0)
            $0.height.equalTo(0)
        }
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
    
    private func showChangeAndAnswerVC(changeAndAnswerVM: ChangeAndAnswerVM) {
        let vc = ChangeAndAnswerVC()
        vc.vm = changeAndAnswerVM
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func showMoreOptions() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
//        alert.addAction(UIAlertAction(title: "그룹 변경", style: .default , handler: { _ in
//        }))

        alert.addAction(UIAlertAction(title: "삭제", style: .destructive , handler: { [weak self] _ in
            guard let self = self else { return }
            self.displayPopup(popup: self.deleteConfirmPopup)
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
        moreButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showMoreOptions()
//                self.displayPopup(popup: self.deleteConfirmPopup)
            }).disposed(by: disposeBag)
        
        deleteConfirmPopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        deleteConfirmPopup.secondButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        prayDetailView.rx.longPressGesture().when(.began)
            .subscribe(onNext: { [weak self] _ in
                self?.showPrayReactionPopupView()
            }).disposed(by: disposeBag)
        
        reactionBgView.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.hidePrayReactionPopupView()
            }).disposed(by: disposeBag)
        
        prayButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let vm = self?.vm else { return }
                self?.coordinator?.didTapPrayButton(vm: vm)
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let tapReactionView = prayDetailView.reactionView.rx.tapGesture().when(.ended).map { _ in () }.asDriver(onErrorJustReturn: ())
        let replys = prayDetailView.replyView.rx.tapGesture().when(.ended).map { _ in () }
        let input = VM.Input(updatePray: updateButton.rx.tap.asDriver(),
                             deletePray: deleteConfirmPopup.firstButton.rx.tap.asDriver(),
                             addPrayPlus: prayPlusButton.rx.tap.asDriver(),
                             addChange: addChangeButton.rx.tap.asDriver(),
                             addAnswer: addAnswerButton.rx.tap.asDriver(),
                             didTapPrayReaction: tapReactionView,
                             showReplys: replys.asDriver(onErrorJustReturn: ())
        )
        let output = vm.transform(input: input)
        
        output.isMyPray
            .drive(onNext: { [weak self] isMyPray in
                guard let self = self else { return }
                self.isMyPray = isMyPray
                self.updateButton.isEnabled = isMyPray
                self.updateButton.title = isMyPray ? "저장" : ""
                self.moreButton.isHidden = !isMyPray
                self.prayPlusButton.isHidden = isMyPray
                self.addChangeButton.isHidden = !isMyPray
                self.addAnswerButton.isHidden = !isMyPray
            }).disposed(by: disposeBag)
        
        output.memberName
            .drive(onNext: { [weak self] name in
                self?.title = name
            }).disposed(by: disposeBag)
        output.updatePraySuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showTopToast(type: .success, message: "기도 저장 완료", disposeBag: self.disposeBag)
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        output.updatePrayFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showTopToast(type: .failure, message: "알 수 없는 문제가 발생하였습니다.", disposeBag: self.disposeBag)
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        output.deletePraySuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        output.deletePrayFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        output.isSuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.hidePrayReactionPopupView()
            }).disposed(by: disposeBag)
        
        output.prayReactionDetailVM
            .drive(onNext: { [weak self] prayReactionDetailVM in
                guard let prayReactionDetailVM = prayReactionDetailVM else { return }
                self?.showReactionView(prayReactionDetailVM: prayReactionDetailVM)
            }).disposed(by: disposeBag)
        
        output.prayPlusAndChangeVM
            .drive(onNext: { [weak self] prayPlusAndChangeVM in
                guard let prayPlusAndChangeVM = prayPlusAndChangeVM else { return }
                self?.showPrayPlusAndChangeVC(prayPlusAndChangeVM: prayPlusAndChangeVM)
            }).disposed(by: disposeBag)
        
        output.prayReplyDetailVM
            .drive(onNext: { [weak self] prayReplyDetailVM in
                guard let prayReplyDetailVM = prayReplyDetailVM else { return }
                self?.showReplyView(prayReplyDetailVM: prayReplyDetailVM)
            }).disposed(by: disposeBag)
        
        output.changeAndAnswerVM
            .drive(onNext: { [weak self] changeAndAnswerVM in
                guard let changeAndAnswerVM = changeAndAnswerVM else { return }
                self?.showChangeAndAnswerVC(changeAndAnswerVM: changeAndAnswerVM)
            }).disposed(by: disposeBag)
    }
    
    private func showPrayPlusAndChangeVC(prayPlusAndChangeVM: AddReplyAndChangeVM) {
        let vc = AddReplyAndChangeVC()
        vc.vm = prayPlusAndChangeVM
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet

        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        present(nav, animated: true, completion: nil)
    }
}

protocol GroupPrayDetailVCDelegate: AnyObject {
    func didTapPrayButton(vm: MyPrayDetailVM)
}

extension MyPrayDetailVC: ReactionPopupViewDelegate {
    func didTapEmoji(type: PrayReactionType) {
        vm?.addReaction(type: type)
    }
    
    func didTapCopy() {
        
    }
}
