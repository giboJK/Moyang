//
//  GroupThanksView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/09/10.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class GroupThanksView: UIView {
    typealias VM = GroupActivityVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    
    let thanksLabel = UILabel().then {
        $0.text = "오늘의 감사는 무엇인가요?"
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep2
    }
    let thanksTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
    }
    // MARK: - UI
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        setupThanksLabel()
        setupThanksTextView()
    }
    private func setupThanksLabel() {
        addSubview(thanksLabel)
        thanksLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupThanksTextView() {
        addSubview(thanksTextView)
        thanksTextView.snp.makeConstraints {
            $0.top.equalTo(thanksLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(80)
        }
    }
    
    // MARK: - Binding
    func bind() {
        bineViews()
        bindVM()
    }
    private func bineViews() {

    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
//        let input = VM.Input(showBibleSelect: addVerseButton.rx.tap.asDriver())
//
//        let _ = vm.transform(input: input)
    }
}
