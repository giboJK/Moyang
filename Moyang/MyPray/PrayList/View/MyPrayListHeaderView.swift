//
//  MyPrayListHeaderView.swift
//  Moyang
//
//  Created by 정김기보 on 2022/11/09.
//

import UIKit

class MyPrayListHeaderView: UITableViewHeaderFooterView {
    let title = MoyangLabel().then {
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
        title.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .nightSky1

        contentView.addSubview(title)
        NSLayoutConstraint.activate([
        
            title.heightAnchor.constraint(equalToConstant: 48),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                   constant: 20),
            title.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
}
