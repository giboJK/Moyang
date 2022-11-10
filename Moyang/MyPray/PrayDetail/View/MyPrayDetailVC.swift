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
    let headerHeight: CGFloat = 12 + 36 + 196
    let minHeaderHeight: CGFloat = 12 + 36 + 12
    var groupList = [String]()
    
    // MARK: - UI
    let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)
    let headerView = PrayDetailHeader()
    let prayTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(MyPrayDetailTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 60
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    let bottomView = MyPrayBottomView()
    
    let deleteConfirmPopup = MoyangPopupView(style: .twoButton, firstButtonStyle: .warning, secondButtonStyle: .sheepGhost).then {
        $0.desc = "정말로 삭제하시겠어요? 삭제한 기도는 복구할 수 없습니다."
        $0.firstButton.setTitle("삭제", for: .normal)
        $0.secondButton.setTitle("취소", for: .normal)
    }
    let deleteFailurePopup = MoyangPopupView(style: .oneButton, firstButtonStyle: .nightPrimary).then {
        $0.desc = "삭제에 실패하였습니다. 잠시 후 다시 시도해주세요/"
        $0.firstButton.setTitle("확인", for: .normal)
    }
    
    let indicator = UIActivityIndicatorView(style: .large).then {
        $0.hidesWhenStopped = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bind()
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
    
    func setupUI() {
        title = "기도"
        view.backgroundColor = .nightSky1
        setupSaveButton()
        setupPrayTableView()
        setupHeader()
        setupBottomView()
    }
    private func setupSaveButton() {
        navigationItem.rightBarButtonItem = saveButton
//        navigationItem.rightBarButtonItems = [saveButton]
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
            $0.height.equalTo(48 + UIApplication.bottomInset)
        }
    }
    
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    
    private func bindViews() {
        bottomView.deleteContainer.rx.tapGesture().when(.ended)
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
        
        deleteFailurePopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
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
                    let headerMaxInset = self.headerHeight - self.minHeaderHeight
                    let headerInset = min(headerMaxInset, self.headerHeight + contentOffset.y)
                    self.headerView.snp.updateConstraints {
                        $0.top.equalTo(self.view.safeAreaLayoutGuide).inset(-headerInset)
                    }
                }
            }).disposed(by: disposeBag)
        
        view.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        
        let input = VM.Input(updatePray: saveButton.rx.tap.asDriver(),
                             deleteItem: prayTableView.rx.itemDeleted.asDriver(),
                             deletePray: deleteConfirmPopup.firstButton.rx.tap.asDriver()
        )
        let output = vm.transform(input: input)
        
        output.isSaveEnabled
            .drive(saveButton.rx.isEnabled)
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
                guard let self = self else { return }
                self.displayPopup(popup: self.deleteFailurePopup)
            }).disposed(by: disposeBag)
        
        output.contentItemList
            .drive(prayTableView.rx
                .items(cellIdentifier: "cell", cellType: MyPrayDetailTVCell.self)) { (_, item, cell) in
                    cell.contentLabel.text = item.content
                    cell.dateLabel.text = item.date.isoToDateString("yyyy.M.d.")
                    cell.updateUI(type: item.type)
                }.disposed(by: disposeBag)
    }
}

protocol MyPrayDetailVCDelegate: AnyObject {
    func didTapPrayButton(vm: GroupPrayingVM)
}
