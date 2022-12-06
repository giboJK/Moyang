//
//  MyPrayListHeaderView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/11/09.
//

import UIKit

class MyPrayListHeaderView: UITableViewHeaderFooterView {
    let titleLabel = MoyangLabel().then {
        $0.textColor = .sheep1
        $0.font = .headline
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        backgroundColor = .nightSky1
        tintColor = .nightSky1
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(21)
            $0.left.equalToSuperview().inset(24)
            $0.top.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
}
