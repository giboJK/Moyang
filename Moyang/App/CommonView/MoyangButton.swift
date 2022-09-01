//
//  MoyangButton.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/08.
//

import UIKit
import RxCocoa
import RxSwift

class MoyangButton: UIButton {
    enum MoyangButtonStyle {
        case primary
        case secondary
        case warning
        case cancel
        case ghost
        case none
    }
    
    private var style: MoyangButtonStyle = .none
    
    override var isEnabled: Bool {
        didSet {
            self.setupUI()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.setupUI()
        }
    }
    
    var isChecked: Bool = false {
        didSet {
            self.setupUI()
        }
    }
    
    var font: UIFont = .systemFont(ofSize: 14, weight: .regular)
    
    let outerCircleView = UIView().then {
        $0.backgroundColor = .sheep1
        $0.layer.borderColor = .nightSky3
        $0.layer.borderWidth = 1
    }
    let innerCircleView = UIView()
    
    required init(style: MoyangButtonStyle) {
        super.init(frame: .zero)
        self.style = style
        setupUI()
    }
    
    convenience init(_ style: MoyangButtonStyle) {
        self.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - setupUI
    private func setupUI() {
        switch style {
        case .primary:
            setupPrimaryButton()
        case .secondary:
            setupSecondaryButton()
        case .warning:
            setupWarningButton()
        case .cancel:
            setupCancelButton()
        case .ghost:
            setupGhostButton()
        case .none:
            break
        }
        
        UIView.animate(withDuration: 0) {
            self.layoutIfNeeded()
        }
    }
    
    private func setupPrimaryButton() {
        layer.cornerRadius = 14
        layer.masksToBounds = true
        setTitleColor(.nightSky1, for: .normal)
        setTitleColor(.sheep4, for: .disabled)
        setTitleColor(.sheep3, for: .highlighted)
        backgroundColor = (isEnabled && !isHighlighted) ? .sheep2 : .sheep5
        
    }
    
    private func setupSecondaryButton() {
        layer.cornerRadius = 14
        layer.masksToBounds = true
        setTitleColor(.sheep1, for: .normal)
        setTitleColor(.sheep4, for: .disabled)
        setTitleColor(.sheep3, for: .highlighted)
        backgroundColor = (isEnabled && !isHighlighted) ? .nightSky3 : .sheep5
    }
    
    private func setupWarningButton() {
        layer.cornerRadius = 14
        layer.masksToBounds = true
        setTitleColor(.sheep1, for: .normal)
        setTitleColor(.sheep4, for: .disabled)
        setTitleColor(.sheep3, for: .highlighted)
        backgroundColor = (isEnabled && !isHighlighted) ? .appleRed2 : .appleRed1
    }
    
    private func setupCancelButton() {
        layer.cornerRadius = 14
        layer.masksToBounds = true
        setTitleColor(.sheep1, for: .normal)
        setTitleColor(.sheep4, for: .disabled)
        setTitleColor(.sheep3, for: .highlighted)
        backgroundColor = (isEnabled && !isHighlighted) ? .sheep4 : .sheep5
    }
    
    
    private func setupGhostButton() {
        setTitleColor(.nightSky3, for: .normal)
        setTitleColor(.sheep4, for: .disabled)
        setTitleColor(.nightSky4, for: .highlighted)
        backgroundColor = .clear
    }
}

extension Reactive where Base: MoyangButton {
    private func controlPropertyWithDefaultEvents<T>(
        editingEvents: UIControl.Event = [.allEditingEvents, .valueChanged],
        getter: @escaping (Base) -> T,
        setter: @escaping (Base, T) -> Void) -> ControlProperty<T> {
            return controlProperty(
                editingEvents: editingEvents,
                getter: getter,
                setter: setter
            )
        }
    var isChecked: ControlProperty<Bool> {
        return base.rx.controlPropertyWithDefaultEvents(
            getter: { base in
                base.isChecked
            }, setter: { base, value in
                base.isChecked = value
            }
        )
    }
}
