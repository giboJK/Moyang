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
    var coordinator: MyPrayDetailVCDelegate?

    // MARK: - Property
    let historyBgViewHeight: CGFloat = 12 + 21 + 16
    let headerHeight: CGFloat = 247 + 12 + 21 + 16
    
    // MARK: - UI
    let moreButton = UIBarButtonItem(title: "상세 보기", style: .plain, target: nil, action: nil)
    let headerView = PrayDetailHeader().then {
        $0.categoryTextField.isUserInteractionEnabled = false
        $0.groupTextField.isUserInteractionEnabled = false
    }
    let historyBgView = UIView().then {
        $0.backgroundColor = .nightSky1
    }
    let historyLabel = MoyangLabel().then {
        $0.text = "히스토리"
        $0.textColor = .wilderness1
        $0.font = .headline
    }
    let prayTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(MyPrayDetailTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .nightSky1
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 60
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    let bottomView = MyPrayBottomView()
    
    let deleteConfirmPopup = MoyangPopupView(style: .twoButton, firstButtonStyle: .warning, secondButtonStyle: .sheepGhost).then {
        $0.desc = "정말로 다른 사람의 기도문이 보이지 않도록 하시겠어요?"
        $0.firstButton.setTitle("숨김", for: .normal)
        $0.secondButton.setTitle("취소", for: .normal)
    }
    
    let cantEditPopup = MoyangPopupView(style: .oneButton, firstButtonStyle: .nightPrimary).then {
        $0.desc = "다른 사람의 기도문은 수정할 수 없어요."
        $0.firstButton.setTitle("확인", for: .normal)
    }
    
    let indicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardObserverSet),
                                               name: NSNotification.Name.MyPrayDetailVCKeyboard, object: nil)
        
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    // 기도하기 화면 후 복귀 시 필요
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    deinit { Log.i(self) }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            UIView.animate(withDuration: 0.7) {
                self.bottomView.snp.updateConstraints {
                    $0.bottom.equalToSuperview().inset(-UIApplication.bottomInset)
                }
                self.view.frame.origin.y = -keyboardSize.height
            }
        }
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomView.snp.updateConstraints {
            $0.bottom.equalToSuperview()
        }
        view.frame.origin.y = 0
        view.layoutIfNeeded()
    }
    @objc func keyboardObserverSet(notification: NSNotification) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupUI() {
        title = "기도"
        view.backgroundColor = .nightSky1
        setupMoreButton()
        setupBottomView()
        setupPrayTableView()
        setupHeader()
        setupHistoryBgView()
        setupHistoryLabel()
    }
    private func setupMoreButton() {
        navigationItem.rightBarButtonItem = moreButton
    }
    private func setupHistoryBgView() {
        view.addSubview(historyBgView)
        historyBgView.snp.makeConstraints {
            $0.height.equalTo(historyBgViewHeight)
            $0.top.equalTo(headerView.snp.bottom).offset(-historyBgViewHeight)
            $0.left.right.equalToSuperview()
        }
    }
    private func setupHistoryLabel() {
        view.addSubview(historyLabel)
        historyLabel.snp.makeConstraints {
            $0.top.equalTo(historyBgView).inset(12)
            $0.height.equalTo(21)
            $0.left.equalToSuperview().inset(24)
        }
    }
    
    private func setupPrayTableView() {
        view.addSubview(prayTableView)
        prayTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(bottomView.snp.top)
        }
        prayTableView.contentInset.top = headerHeight
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 12)).then {
            $0.backgroundColor = .clear
        }
        prayTableView.tableFooterView = footer
        prayTableView.delegate = self
        prayTableView.setContentOffset(CGPoint(x: 0, y: -headerHeight), animated: false)
    }
    private func setupHeader() {
        view.addSubview(headerView)
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(0)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(headerHeight)
        }
        headerView.vm = vm
        headerView.disposeBag = disposeBag
        headerView.bind()
    }
    
    private func setupBottomView() {
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
    private func showAlert() {
        let alert = UIAlertController()
        
        alert.addAction(UIAlertAction(title: "변화", style: .default, handler: { [weak self] _ in
            self?.vm?.changeType(type: .change)
        }))
        
        alert.addAction(UIAlertAction(title: "응답", style: .default, handler: { [weak self] _ in
            self?.vm?.changeType(type: .answer)
        }))

        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { _ in
        }))

        self.present(alert, animated: true)
    }
    
    private func showFixVC() {
        let vc = MyPrayFixVC()
        vc.vm = self.vm
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
//    private func showReactionView(prayReactionDetailVM: PrayReactionDetailVM) {
//        let vc = PrayReactionDetailVC()
//        vc.vm = prayReactionDetailVM
//        let nav = UINavigationController(rootViewController: vc)
//        nav.modalPresentationStyle = .pageSheet
//
//        if let sheet = nav.sheetPresentationController {
//            sheet.detents = [.medium(), .large()]
//        }
//        present(nav, animated: true, completion: nil)
//    }
    
    
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
        moreButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                guard let vm = self?.vm else { return }
                self?.coordinator?.didTapMoreButton(vm: vm)
            }).disposed(by: disposeBag)
        
        prayTableView.rx.contentOffset
            .skip(.milliseconds(500), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] contentOffset in
                guard let self = self else { return }
                if contentOffset.y < -self.headerHeight {
                    self.headerView.snp.updateConstraints {
                        $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(abs(self.headerHeight+contentOffset.y))
                    }
                } else {
                    let headerMaxInset = self.headerHeight - self.historyBgViewHeight
                    let headerInset = min(headerMaxInset, self.headerHeight + contentOffset.y)
                    self.headerView.snp.updateConstraints {
                        $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(-headerInset)
                    }
                }
            }).disposed(by: disposeBag)
        
        bottomView.typeContainer.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.showAlert()
            }).disposed(by: disposeBag)
        
        prayTableView.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            }).disposed(by: disposeBag)
        
        cantEditPopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        deleteConfirmPopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        deleteConfirmPopup.secondButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        
        let addNew = bottomView.textView.saveImageView.rx.tapGesture().when(.ended).map({ _ in ()}).asDriver(onErrorJustReturn: ())
        let input = VM.Input(startPray: .empty(), // bottomView.prayButton.rx.tap.asDriver(),
                             setNew: bottomView.textView.textView.rx.text.asDriver(),
                             addNew: addNew)
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
        
        output.updatePraySuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.showTopToast(type: .success, message: "기도 저장 완료", disposeBag: self.disposeBag)
            }).disposed(by: disposeBag)
        
        output.contentItemList
            .drive(prayTableView.rx
                .items(cellIdentifier: "cell", cellType: MyPrayDetailTVCell.self)) { (_, item, cell) in
                    cell.contentLabel.text = item.content
                    cell.dateLabel.text = item.date.isoToDateString("yyyy.M.d.")
                    cell.nameLabel.text = item.name
                    cell.updateUI(type: item.type)
                }.disposed(by: disposeBag)
        
        output.contentItemList.map { $0.count }
            .drive(onNext: { [weak self] count in
                if count == 0 { return }
                self?.prayTableView.scrollToRow(at: IndexPath(row: count - 1, section: 0), at: .top, animated: true)
                self?.bottomView.textView.textView.text = nil
            }).disposed(by: disposeBag)
        
        output.newContentTypeString
            .drive(bottomView.typeLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.deletePraySuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        Driver.combineLatest(output.addChangeSuccess,
                             output.addAnswerSuccess)
        .skip(2).delay(.milliseconds(100))
        .drive(onNext: { [weak self](_, _) in
            guard let self = self else { return }
            let numberOfRows = self.prayTableView.numberOfRows(inSection: 0) - 1
            guard numberOfRows > 0 else { return }
            self.prayTableView.scrollToRow(at: IndexPath(row: numberOfRows, section: 0), at: .bottom, animated: true)
            self.bottomView.textView.textView.text.removeAll()
        }).disposed(by: disposeBag)
        
        output.cantEditPopup
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.cantEditPopup)
            }).disposed(by: disposeBag)
        
        output.deleteConfirmPopup
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.deleteConfirmPopup)
            }).disposed(by: disposeBag)
        
        output.showFixVC
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.showFixVC()
            }).disposed(by: disposeBag)
        
        output.prayingVM
            .drive(onNext: { [weak self] prayingVM in
                guard let prayingVM = prayingVM else { return }
                self?.coordinator?.didTapPrayButton(vm: prayingVM)
            }).disposed(by: disposeBag)
    }
}

extension MyPrayDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "수정",
                                        handler: { [weak self] (_, _, success: (Bool) -> Void) in
            success(true)
            self?.vm?.checkCanEdit(indexPath: indexPath)
        })
        
        action.image = UIImage(named: "")
        action.backgroundColor = UIColor.nightSky4
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row == 0 {
            return nil
        }
        
        let action = UIContextualAction(style: .normal, title: "삭제",
                                        handler: { [weak self] (_, _, success: (Bool) -> Void) in
            success(true)
            self?.vm?.checkCanDelete(indexPath: indexPath)
        })
        
        action.image = UIImage(named: "")
        action.backgroundColor = UIColor.red
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}

protocol MyPrayDetailVCDelegate: AnyObject {
    func didTapMoreButton(vm: MyPrayDetailVM)
    func didTapPrayButton(vm: MyPrayPrayingVM)
}
