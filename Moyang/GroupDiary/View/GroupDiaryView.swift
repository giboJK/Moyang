//
//  GroupDiaryView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/09/10.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class GroupDiaryView: UIView {
    typealias VM = GroupActivityVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    
    let titleLabel = UILabel().then {
        $0.text = "지금 주님과 어떻게 동행하고 있나요?"
        $0.font = .systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .sheep2
    }
    let thanksTextView = UITextView().then {
        $0.backgroundColor = .sheep1
        $0.layer.cornerRadius = 8
        $0.textContainerInset = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        $0.font = .systemFont(ofSize: 15, weight: .regular)
        $0.textColor = .nightSky1
    }
    let emojiBgView = UIView().then {
        $0.backgroundColor = .sheep1
    }
    let sadLabel = UILabel().then {
        $0.text = "😢"
    }
    let fearLabel = UILabel().then {
        $0.text = "😨"
    }
    let relievedLabel = UILabel().then {
        $0.text = "😌"
    }
    let smileLabel = UILabel().then {
        $0.text = "😁"
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
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.right.equalToSuperview().inset(20)
        }
    }
    private func setupThanksTextView() {
        addSubview(thanksTextView)
        thanksTextView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
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
