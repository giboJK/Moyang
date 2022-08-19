//
//  ChangeAnswerTVCell.swift
//  Moyang
//
//  Created by 정김기보 on 2022/08/18.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift
import RxGesture

class ChangeAnswerTVCell: UITableViewCell {
    typealias VM = ChangeAndAnswerVM
    var disposeBag: DisposeBag = DisposeBag()
    var vm: VM?
    var isBinded = false
    var type = ChangeAnswertype.change
    
    enum ChangeAnswertype: Int {
        case pray = 0
        case change = 1
        case answer = 2
    }
    
    let dateLabel = UILabel().then {
        $0.textColor = .sheep1
        $0.font = .systemFont(ofSize: 16, weight: .regular)
    }
    let typeLabel = UILabel().then {
        $0.textColor = .sheep1
        $0.font = .systemFont(ofSize: 16, weight: .regular)
    }
    let contentLabel = UILabel().then {
        $0.textColor = .sheep1
        $0.font = .systemFont(ofSize: 18, weight: .regular)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .sheep1
        selectedBackgroundView = backgroundView
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - UI
    private func setupUI() {
        contentView.backgroundColor = .sheep1
        setupDateLabel()
        setupTypeLabel()
        setupContentLabel()
    }
    
    private func setupDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(12)
            $0.top.equalToSuperview().inset(20)
        }
    }
    private func setupTypeLabel() {
        contentView.addSubview(typeLabel)
        typeLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(12)
            $0.top.equalToSuperview().inset(20)
        }
    }
    private func setupContentLabel() {
        contentView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(12)
            $0.top.equalTo(dateLabel.snp.bottom).offset(20)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    func setBg() {
        switch self.type {
        case .pray:
            typeLabel.text = "기도"
            contentView.backgroundColor = .ydGreen1
        case .change:
            typeLabel.text = "변화"
            contentView.backgroundColor = .nightSky3
        case .answer:
            typeLabel.text = "응답"
            contentView.backgroundColor = .wilderness1
        }
    }
}
