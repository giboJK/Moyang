//
//  GroupSearchVC.swift
//  Moyang
//
//  Created by kibo on 2022/11/18.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class GroupSearchVC: UIViewController, VCType {
    typealias VM = GroupSearchVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var coordinator: GroupSearchVCDelegate?

    // MARK: - UI
    let groupTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(GroupSearchTVCell.self, forCellReuseIdentifier: "cell")
        $0.backgroundColor = .clear
        $0.separatorStyle = .none
        $0.estimatedRowHeight = 102
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isScrollEnabled = true
    }
    let askAgainPopup = MoyangPopupView(style: .twoButton, firstButtonStyle: .nightPrimary, secondButtonStyle: .nightGhost).then {
        $0.title = "공동체 들어가기"
        $0.desc = "입장 요청"
        $0.firstButton.setTitle("요청하기", for: .normal)
        $0.secondButton.setTitle("취소", for: .normal)
    }
    let successPopup = MoyangPopupView(style: .oneButton, firstButtonStyle: .nightPrimary).then {
        $0.title = "요청이 완료되었습니다"
        $0.firstButton.setTitle("확인", for: .normal)
    }
    let failurePopup = MoyangPopupView(style: .oneButton, firstButtonStyle: .warning).then {
        $0.title = "요청이 실패하였습니다"
        $0.desc = "개발자에게 문의하세요"
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
        .lightContent
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    func setupUI() {
        title = "공동체 찾기"
        view.backgroundColor = .nightSky1
        setupGroupTableView()
        setupIndicator()
    }
    
    private func setupGroupTableView() {
        view.addSubview(groupTableView)
        groupTableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    private func setupIndicator() {
        view.addSubview(indicator)
        indicator.snp.makeConstraints {
            $0.size.equalTo(60)
            $0.center.equalToSuperview()
        }
    }

    // MARK: - Binding
    func bind() {
        bindVM()
        bindViews()
    }
    private func bindViews() {
        
        askAgainPopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        askAgainPopup.secondButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        successPopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        failurePopup.firstButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.closePopup()
            }).disposed(by: disposeBag)
        
        groupTableView.rx.contentOffset.asDriver()
            .throttle(.seconds(1))
            .drive(onNext: { [weak self] offset in
                guard let self = self else { return }
                let offset = self.groupTableView.contentOffset.y
                let maxOffset = self.groupTableView.contentSize.height - self.groupTableView.frame.size.height
                if maxOffset - offset <= 0 {
                    self.vm?.fetchMoreGroupList()
                }
            }).disposed(by: disposeBag)
    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input(requestJoin: askAgainPopup.firstButton.rx.tap.asDriver())
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
        
        output.groupList
            .drive(groupTableView.rx
                .items(cellIdentifier: "cell", cellType: GroupSearchTVCell.self)) { [weak self] (indexPath, item, cell) in
                    cell.nameLabel.text = item.name
                    cell.descLabel.text = item.desc
                    cell.leaderLabel.text = item.leader
                    cell.index = indexPath
                    cell.vm = self?.vm
                    cell.bind()
                }.disposed(by: disposeBag)
        
        output.selectedGroupInfo
            .drive(askAgainPopup.descLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.requestConfirm.skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.askAgainPopup)
            }).disposed(by: disposeBag)
        
        output.joinGroupReqSuccess
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.successPopup)
            }).disposed(by: disposeBag)
        
        output.joinGroupReqFailure
            .skip(1)
            .drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.displayPopup(popup: self.failurePopup)
            }).disposed(by: disposeBag)
    }
}

protocol GroupSearchVCDelegate: AnyObject {

}
