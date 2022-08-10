//
//  TaskListView.swift
//  Moyang
//
//  Created by kibo on 2022/08/10.
//

import UIKit
import RxSwift
import SnapKit
import Then
import RxCocoa

class TaskListView: UIView {
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textColor = .sheep1
    }
    let container = UIView()
    var itemViewList = [TaskItemView]()
    
    let itemViewHeight: Int = 104
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        setupTimeLabel()
        setupContainer()
    }
    
    private func setupTimeLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().inset(8)
        }
    }
    private func setupContainer() {
        addSubview(container)
        container.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func setItemList(list: [TodayVM.TodayTaskItem]) {
        // 서버에서 1 ~ 4 개의 할 일을 보내준다
        for i in 0..<list.count {
            if i == 0 {
                if list.count == 1 {
                    let itemView = TaskItemView(type: .one, item: list[i])
                    container.addSubview(itemView)
                    itemView.snp.makeConstraints {
                        $0.edges.equalToSuperview()
                        $0.height.equalTo(itemViewHeight)
                    }
                } else {
                    let itemView = TaskItemView(type: .first, item: list[i])
                    container.addSubview(itemView)
                    itemView.snp.makeConstraints {
                        $0.top.equalToSuperview()
                        $0.left.right.equalToSuperview()
                        $0.height.equalTo(itemViewHeight)
                    }
                }
            } else if i == (list.count - 1) {
                let itemView = TaskItemView(type: .last, item: list[i])
                container.addSubview(itemView)
                itemView.snp.makeConstraints {
                    $0.top.equalToSuperview().inset(i * itemViewHeight)
                    $0.left.right.equalToSuperview()
                    $0.bottom.equalToSuperview()
                    $0.height.equalTo(itemViewHeight)
                }
            } else {
                let itemView = TaskItemView(type: .middle, item: list[i])
                container.addSubview(itemView)
                itemView.snp.makeConstraints {
                    $0.top.equalToSuperview().inset(i * itemViewHeight)
                    $0.left.right.equalToSuperview()
                    $0.height.equalTo(itemViewHeight)
                }
            }
        }
    }
}
