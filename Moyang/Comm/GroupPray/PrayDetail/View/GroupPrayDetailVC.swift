//
//  GroupPrayDetailVC.swift
//  Moyang
//
//  Created by kibo on 2022/08/04.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupPrayDetailVC: UIViewController, VCType {
    typealias VM = GroupPrayDetailVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupPrayDetailVCDelegate?

    // MARK: - UI
    let navBar = MoyangNavBar(.light).then {
        $0.closeButton.isHidden = true
        $0.title = "기도제목"
    }
    let updateButton = UIButton().then {
        $0.setTitle("저장", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        $0.setTitleColor(.nightSky2, for: .normal)
        $0.setTitleColor(.ydGreen1, for: .disabled)
    }
    let prayDetailView = PrayDetailView()
    let prayButton = MoyangButton(.primary).then {
        $0.setTitle("기도하기", for: .normal)
    }
    let deleteButton = MoyangButton(.warning).then {
        $0.setTitle("삭제", for: .normal)
    }
    let prayPlusButton = MoyangButton(.secondary).then {
        $0.setTitle("기도문 더하기", for: .normal)
    }
    let prayChangeLabel = UILabel().then {
        $0.text = "기도 변화"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .nightSky1
    }
    let addChangeButton = MoyangButton(.none).then {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        $0.tintColor = .nightSky1
    }
    let divider = UIView().then {
        $0.backgroundColor = .sheep3
    }
    let prayAnswerLabel = UILabel().then {
        $0.text = "기도 응답"
        $0.font = .systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .nightSky1
    }
    let addAnswerButton = MoyangButton(.none).then {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        $0.tintColor = .nightSky1
    }
    let deleteConfirmPopup = MoyangPopupView(style: .twoButton, firstButtonStyle: .warning, secondButtonStyle: .ghost).then {
        $0.desc = "정말로 삭제하시겠어요? 삭제한 기도는 복구할 수 없습니다."
        $0.firstButton.setTitle("삭제", for: .normal)
        $0.secondButton.setTitle("취소", for: .normal)
    }
    let reactionBgView = UIView().then {
        $0.isHidden = true
    }
    let reactionView = ReactionPopupView().then {
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

    deinit { Log.i(self) }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    func setupUI() {
        view.backgroundColor = .sheep2
        setupNavBar()
        setupPrayDetailView()
        setupPrayChangeView()
        setupPrayAnswerView()
        setupDeleteButton()
        setupPrayPlusButton()
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
        setupUpdateButton()
    }
    private func setupUpdateButton() {
        navBar.addSubview(updateButton)
        updateButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(10)
            $0.height.equalTo(20)
        }
    }
    private func setupPrayDetailView() {
        view.addSubview(prayDetailView)
        prayDetailView.snp.makeConstraints {
            $0.top.equalTo(navBar.snp.bottom)
            $0.left.right.equalToSuperview()
        }
        prayDetailView.vm = vm
        prayDetailView.bind()
    }
    private func setupPrayChangeView() {
        view.addSubview(prayChangeLabel)
        prayChangeLabel.snp.makeConstraints {
            $0.top.equalTo(prayDetailView.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(20)
        }
        
        view.addSubview(addChangeButton)
        addChangeButton.snp.makeConstraints {
            $0.centerY.equalTo(prayChangeLabel)
            $0.right.equalToSuperview().inset(20)
        }
        
        view.addSubview(divider)
        divider.snp.makeConstraints {
            $0.top.equalTo(prayChangeLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
    }
    private func setupPrayAnswerView() {
        view.addSubview(prayAnswerLabel)
        prayAnswerLabel.snp.makeConstraints {
            $0.top.equalTo(divider.snp.bottom).offset(12)
            $0.left.equalToSuperview().inset(20)
        }
        
        view.addSubview(addAnswerButton)
        addAnswerButton.snp.makeConstraints {
            $0.centerY.equalTo(prayAnswerLabel)
            $0.right.equalToSuperview().inset(20)
        }
    }
    private func setupDeleteButton() {
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
    private func setupPrayPlusButton() {
        view.addSubview(prayPlusButton)
        prayPlusButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(12)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
    private func setupPrayButton() {
        view.addSubview(prayButton)
        prayButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(80)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
    private func setupReactionView() {
        view.addSubview(reactionBgView)
        reactionBgView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        view.addSubview(reactionView)
        reactionView.snp.makeConstraints {
            $0.width.equalTo(0)
            $0.height.equalTo(0)
            $0.right.equalTo(prayDetailView).inset(16)
            $0.top.equalTo(prayDetailView).inset(280)
        }
        reactionView.delegate = self
    }
    func showPrayReactionPopupView() {
        if isMyPray || isPopupAnimating {
            return
        }
        isPopupAnimating = true
        reactionBgView.isHidden = false
        reactionView.isHidden = false
        reactionView.snp.updateConstraints {
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
        reactionView.isHidden = true
        reactionView.snp.updateConstraints {
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
    
    // MARK: - Binding
    func bind() {
        bineViews()
        bindVM()
    }
    
    private func bineViews() {
        navBar.backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.deleteConfirmPopup)
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
        let input = VM.Input(updatePray: updateButton.rx.tap.asDriver(),
                             deletePray: deleteConfirmPopup.firstButton.rx.tap.asDriver(),
                             addPrayPlus: prayPlusButton.rx.tap.asDriver(),
                             addChange: addChangeButton.rx.tap.asDriver(),
                             addAnswer: addAnswerButton.rx.tap.asDriver(),
                             didTapPrayReaction: tapReactionView)
        let output = vm.transform(input: input)
        
        output.isMyPray
            .drive(onNext: { [weak self] isMyPray in
                guard let self = self else { return }
                self.isMyPray = isMyPray
                self.updateButton.isHidden = !isMyPray
                self.deleteButton.isHidden = !isMyPray
                self.prayPlusButton.isHidden = isMyPray
                self.addChangeButton.isHidden = !isMyPray
                self.addAnswerButton.isHidden = !isMyPray
                self.prayChangeLabel.snp.remakeConstraints {
                    if isMyPray {
                        $0.top.equalTo(self.prayDetailView.snp.bottom).offset(44)
                        $0.left.equalToSuperview().inset(20)
                    } else {
                        $0.top.equalTo(self.prayDetailView.snp.bottom).offset(20)
                        $0.left.equalToSuperview().inset(20)
                    }
                }
            }).disposed(by: disposeBag)
        
        output.changes
            .map { "기도 변화 (\($0.count))" }
            .drive(prayChangeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.answers
            .map { "기도 응답 (\($0.count))" }
            .drive(prayAnswerLabel.rx.text)
            .disposed(by: disposeBag)
        
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
    }
    
    private func showPrayPlusAndChangeVC(prayPlusAndChangeVM: PrayPlusAndChangeVM) {
        let vc = PrayPlusAndChangeVC()
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
    func didTapPrayButton(vm: GroupPrayDetailVM)
}

extension GroupPrayDetailVC: ReactionPopupViewDelegate {
    func didTapEmoji(type: PrayReactionType) {
        vm?.addReaction(type: type)
    }
    
    func didTapCopy() {
        
    }
}
