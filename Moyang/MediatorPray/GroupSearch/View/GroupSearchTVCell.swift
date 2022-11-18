//
//  GroupSearchTVCell.swift
//  Moyang
//
//  Created by kibo on 2022/11/18.
//

import UIKit
import SnapKit
import Then
import RxCocoa
import RxSwift

class GroupSearchTVCell: UITableViewCell {
    typealias VM = GroupSearchVM
    var vm: VM?
    var isBinded = false
    
    // MARK: - UI
    let nameLabel = MoyangLabel()
    let descLabel = MoyangLabel()
    let leaderLabel = MoyangLabel()
    let requestButton = MoyangButton(.sheepPrimary)
    var index = 0
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let backgroundView = UIView()
        backgroundView.backgroundColor = .clear
        selectedBackgroundView = backgroundView
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        setupContentView()
        setupNameLabel()
        setupDescLabel()
        setupLeaderLabel()
        setupRequestButton()
    }
    
    private func setupContentView() {
        contentView.backgroundColor = .nightSky1
    }
    private func setupNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(24)
            $0.height.equalTo(19)
        }
    }
    private func setupDescLabel() {
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(43)
            $0.height.equalTo(14)
        }
    }
    private func setupLeaderLabel() {
        contentView.addSubview(leaderLabel)
        leaderLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(73)
            $0.bottom.equalToSuperview().inset(12)
            $0.height.equalTo(17)
        }
    }
    private func setupRequestButton() {
        contentView.addSubview(requestButton)
        requestButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.width.equalTo(124)
            $0.height.equalTo(40)
            $0.right.equalToSuperview().inset(24)
        }
    }
    
    func bind() {
        if let vm = vm {
            if isBinded { return }
            isBinded = true
            
            let input = VM.Input(selectItem: requestButton.rx.tap.map { self.index }
                .asDriver(onErrorJustReturn: -1))
            _ = vm.transform(input: input)

        }
        
    }
}
