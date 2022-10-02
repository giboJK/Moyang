//
//  MyDiaryView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/09/10.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class MyDiaryView: UIView {
    typealias VM = GroupActivityVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    let descLabel = UILabel().then {
        $0.text = "지금 무엇을 사랑하고 감사하고 있나요?"
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
    }
    
    // MARK: - Binding
    func bind() {
        bindViews()
        bindVM()
    }
    private func bindViews() {

    }

    private func bindVM() {
        guard let vm = vm else { Log.e("vm is nil"); return }
//        let input = VM.Input(showBibleSelect: addVerseButton.rx.tap.asDriver())
//
//        let _ = vm.transform(input: input)
    }
}
