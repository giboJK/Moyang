//
//  MyPrayDetailEditVC.swift
//  Moyang
//
//  Created by kibo on 2022/11/15.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class MyPrayDetailEditVC: UIViewController, VCType {
    typealias VM = MyPrayDetailVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: MyPrayDetailEditVCDelegate?
    
    // MARK: - Property
    let headerHeight: CGFloat = 247 + 12 + 21 + 16
    
    // MARK: - UI
    let saveButton = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)
    let headerView = PrayDetailHeader()
    let deleteButton = MoyangButton(.warning).then {
        $0.setTitle("삭제하기", for: .normal)
    }
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

    deinit { Log.i(self) }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    func setupUI() {
        title = "더 보기"
        view.backgroundColor = .nightSky1
        setupSaveButton()
        setupHeader()
        setupDeleteButton()
    }
    
    private func setupSaveButton() {
        navigationItem.rightBarButtonItem = saveButton
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
    private func setupDeleteButton() {
        view.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(-20)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
    }
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    private func bindViews() {
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
        
        deleteFailurePopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        view.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        
        let input = VM.Input(updatePray: saveButton.rx.tap.asDriver(),
                             resetChange: self.rx.viewWillDisappear.map({ _ in ()}).asDriver(onErrorJustReturn: ()),
                             deletePray: deleteConfirmPopup.firstButton.rx.tap.asDriver()
        )
        let output = vm.transform(input: input)
        
        output.isSaveEnabled
            .drive(saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
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
        
        output.updatePraySuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
    }
}

protocol MyPrayDetailEditVCDelegate: AnyObject {

}
