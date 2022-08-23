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
import RxGesture

class TaskItemView: UIView {
    var disposeBag: DisposeBag = DisposeBag()
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
    let typeImageView = UIImageView()
    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = .sheep1
    }
    let descLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textColor = .sheep2
    }
    let hourglassImageView = UIImageView().then {
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .regular, scale: .large)
        $0.image = UIImage(systemName: "hourglass", withConfiguration: config)
        $0.tintColor = .sheep1
        $0.contentMode = .scaleToFill
    }
    
    let type: TaskOrder
    let item: TodayVM.TodayTaskItem
    
    var tapHandler: (() -> Void)?
    
    init(type: TaskOrder, item: TodayVM.TodayTaskItem) {
        self.type = type
        self.item = item
        super.init(frame: .zero)
        setupUI()
        setData(item: item)
        
        self.rx.tapGesture().when(.ended)
            .subscribe(onNext: { [weak self] _ in
                self?.tapHandler?()
            }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        setupDoneImageView()
        setupContainer()
        setupTypeImageView()
        setupTitleLabel()
        setupHourglassImageView()
        setupDescLabel()
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
    private func setupTypeImageView() {
        container.addSubview(typeImageView)
        typeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalToSuperview().inset(20)
            $0.size.equalTo(24)
        }
    }
    private func setupTitleLabel() {
        container.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20)
            $0.left.equalTo(typeImageView.snp.right).offset(4)
            $0.right.equalToSuperview().inset(20)
        }
    }
    private func setupHourglassImageView() {
        container.addSubview(hourglassImageView)
        hourglassImageView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(16)
            $0.left.equalTo(typeImageView.snp.right).offset(4)
            $0.width.equalTo(12)
            $0.height.equalTo(12)
        }
    }
    private func setupDescLabel() {
        container.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.left.equalTo(hourglassImageView.snp.right).offset(4)
            $0.centerY.equalTo(hourglassImageView)
            $0.right.equalToSuperview().inset(20)
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
        caShapeLayer.lineDashPattern = [5.46, 5.46]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 10, y: 2.73), CGPoint(x: 10, y: 42)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        layer.addSublayer(caShapeLayer)
    }
    func drawBottomLine() {
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = .sheep2
        caShapeLayer.lineWidth = 2
        caShapeLayer.lineDashPattern = [5.46, 5.46]
        let cgPath = CGMutablePath()
        let cgPoint = [CGPoint(x: 10, y: 62), CGPoint(x: 10, y: 104)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        layer.addSublayer(caShapeLayer)
    }
    
    func setType(type: Int) {
        guard let type = TodayTaskType(rawValue: type) else { Log.e("type error"); return }
        titleLabel.text = type.defaultTitle
        descLabel.text = "\(type.defaultTime) 분"
    }
}
