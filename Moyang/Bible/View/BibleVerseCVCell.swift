//
//  BibleVerseCVCell.swift
//  Moyang
//
//  Created by 정김기보 on 2022/09/03.
//

import UIKit
import RxCocoa
import RxSwift
import SnapKit
import Then

class BibleVerseCVCell: UICollectionViewCell {
    typealias VM = BibleSelectVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    
    let verseLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14, weight: .regular)
        $0.tintColor = .sheep2
    }
    let deleteButton = UIButton().then {
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .large)
        $0.setImage(UIImage(systemName: "xmark.app.fill", withConfiguration: config), for: .normal)
        $0.tintColor = .sheep2
    }
    
    private var isBinded = false
    var indexPath: IndexPath?
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .wilderness2
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = true
        setupVerseLabel()
        setupDeleteButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVerseLabel() {
        contentView.addSubview(verseLabel)
        verseLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func setupDeleteButton() {
        contentView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.right.equalToSuperview().inset(4)
            $0.centerY.equalToSuperview()
        }
    }
    
    func bind() {
        if let vm = vm {
            if isBinded { return }
            isBinded = true
            
            let input = VM.Input(deleteVerse: deleteButton.rx.tap.map { self.indexPath }.asDriver(onErrorJustReturn: nil))
            _ = vm.transform(input: input)
        }
    }
}
