//
//  TaskItemView.swift
//  Moyang
//
//  Created by kibo on 2022/08/10.
//

import UIKit
import RxSwift
import SnapKit
import Then
import RxCocoa

class TaskItemView: UIView {
    
    enum TaskOrder {
        case one
        case first
        case middle
        case last
    }
    
    let doneImageView = UIImageView().then {
        $0.tintColor = .sheep2
    }
    let container = UIView().then {
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = .sheep2
        $0.layer.borderWidth = 1
    }
    
    let type: TaskOrder
    let item: TodayVM.TodayTaskItem
    init(type: TaskOrder, item: TodayVM.TodayTaskItem) {
        self.type = type
        self.item = item
        super.init(frame: .zero)
        setupUI()
        setData(item: item)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        setupDoneImageView()
        setupContainer()
        switch type {
        case .one:
            break
        case .first:
            drawBottomLine()
        case .middle:
            drawTopLine()
            drawBottomLine()
        case .last:
            drawTopLine()
        }
    }
    private func setupDoneImageView() {
        addSubview(doneImageView)
        doneImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
            $0.left.equalToSuperview()
        }
    }
    func setupContainer() {
        addSubview(container)
        container.snp.makeConstraints {
            $0.top.bottom.right.equalToSuperview().inset(12)
            $0.left.equalToSuperview().inset(40)
        }
    }
    
    func setData(item: TodayVM.TodayTaskItem) {
        if item.isDone {
            doneImageView.image = UIImage(systemName: "circle.fill")?.withTintColor(.sheep2)
        } else {
            doneImageView.image = UIImage(systemName: "circle.dashed")?.withTintColor(.sheep2)
        }
    }
    
    func drawTopLine() {
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = .sheep2
        caShapeLayer.lineWidth = 2
        caShapeLayer.lineDashPattern = [6, 6]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 10, y: 0), CGPoint(x: 10, y: 42)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        layer.addSublayer(caShapeLayer)
    }
    func drawBottomLine() {
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = .sheep2
        caShapeLayer.lineWidth = 2
        caShapeLayer.lineDashPattern = [6, 6]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 10, y: 62), CGPoint(x: 10, y: 104)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        layer.addSublayer(caShapeLayer)
    }
}
