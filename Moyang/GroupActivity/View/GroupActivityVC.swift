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
    let tabView = GroupActivityTabView()
    
    var myPrayMainVC: MyPrayMainVC?
    var mediatorPrayMainVC: MediatorPrayMainVC?
    var noteMainVC: NoteMainVC?
    
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
        setupTabView()
        
        setupMediatorPrayMainVC()
        setupMyPrayMainVC()
//        setupNoteMainVC()
    }
    private func setupNewsButton() {
        view.addSubview(newsButton)
        newsButton.snp.makeConstraints {
            $0.right.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            $0.size.equalTo(24)
        }
    }
    private func setupTabView() {
        view.addSubview(tabView)
        tabView.snp.makeConstraints {
            $0.top.equalTo(newsButton.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(44)
        }
    }
    
    private func setupMediatorPrayMainVC() {
        guard let vc = mediatorPrayMainVC else { Log.e("MediatorPrayMainVC is nil"); return }
        view.addSubview(vc.view)
        addChild(vc)
        vc.didMove(toParent: self)
        vc.view.snp.makeConstraints {
            $0.top.equalTo(tabView.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
        vc.view.isHidden = !(tabView.tabMenus.first == .mediatorPray)
    }
    private func setupMyPrayMainVC() {
        guard let vc = myPrayMainVC else { Log.e("MyPrayMainVC is nil"); return }
        view.addSubview(vc.view)
        addChild(vc)
        vc.didMove(toParent: self)
        vc.view.snp.makeConstraints {
            $0.top.equalTo(tabView.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
        vc.view.isHidden = !(tabView.tabMenus.first == .pray)
    }
    private func setupNoteMainVC() {
        guard let vc = noteMainVC else { Log.e("NoteMainVC is nil"); return }
        view.addSubview(vc.view)
        addChild(vc)
        vc.didMove(toParent: self)
        vc.view.snp.makeConstraints {
            $0.top.equalTo(tabView.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
//        vc.view.isHidden = !(tabView.tabMenus.first == .worshipNote)
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
        
        tabView.menuCV.rx.itemSelected
            .skip(.milliseconds(200), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] index in
                self?.mediatorPrayMainVC?.view.isHidden = index.row != GroupActivityTabView.TapMenu.mediatorPray.rawValue
                self?.myPrayMainVC?.view.isHidden = index.row != GroupActivityTabView.TapMenu.pray.rawValue
//                self?.noteMainVC?.view.isHidden = index.row != GroupActivityTabView.TapMenu.worshipNote.rawValue
            }).disposed(by: disposeBag)
    }
    
    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
        let input = VM.Input()
        
        let output = vm.transform(input: input)
    }
}

protocol GroupActivityVCDelegate: AnyObject {
    func didTapNewsButton()
}
