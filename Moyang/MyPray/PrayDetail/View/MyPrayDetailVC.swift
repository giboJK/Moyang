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

class MyPrayDetailVC: UIViewController, VCType, UITableViewDelegate, UIGestureRecognizerDelegate {
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
    }
    
    // 기도하기 화면 후 복귀 시 필요
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

    deinit { Log.i(self) }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
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
    
    func setupUI() {
        title = "기도"
        view.backgroundColor = .nightSky1
        setupMoreButton()
        setupPrayTableView()
        setupHeader()
        setupHistoryBgView()
        setupHistoryLabel()
        setupBottomView()
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
            $0.bottom.bottom.equalToSuperview().inset(48 + UIApplication.bottomInset)
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
        headerView.bindViews()
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
        
        view.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        
        let input = VM.Input()
        let output = vm.transform(input: input)
        
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
                    cell.updateUI(type: item.type)
                }.disposed(by: disposeBag)
        
        output.deletePraySuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
}

protocol MyPrayDetailVCDelegate: AnyObject {
    func didTapMoreButton(vm: MyPrayDetailVM)
    func didTapPrayButton(vm: GroupPrayingVM)
}
