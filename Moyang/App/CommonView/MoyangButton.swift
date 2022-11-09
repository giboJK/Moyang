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
        case sheepPrimary
        case sheepSecondary
        case sheepGhost
        
        case nightPrimary
        case nightSecondary
        case nightGhost
        
        case warning
        case cancel
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
        
    }
    
    // MARK: - setupUI
    private func setupUI() {
        layer.masksToBounds = true
        layer.cornerRadius = 10
        titleLabel?.font = .b01
        switch style {
        case .sheepPrimary:
            setupSheepPrimary()
        case .sheepSecondary:
            setupSheepSecondary()
        case .sheepGhost:
            setupSheepGhost()
        case .nightPrimary:
            setupNightPrimary()
        case .nightSecondary:
            setupNightSecondary()
        case .nightGhost:
            setupNightGhost()
        case .warning:
            setupWarning()
        case .cancel:
            setupCancel()
        case .none:
            break
        }
        
        UIView.animate(withDuration: 0) {
            self.layoutIfNeeded()
        }
    }
    // MARK: - Sheep
    private func setupSheepPrimary() {
        setTitleColor(.nightSky1, for: .normal)
        setTitleColor(.sheep4, for: .disabled)
        setTitleColor(.nightSky3, for: .highlighted)
        setBackgroundColor(color: .sheep1, forState: .normal)
        setBackgroundColor(color: .sheep3, forState: .disabled)
        setBackgroundColor(color: .sheep2, forState: .highlighted)
    }
    
    private func setupSheepSecondary() {
        setTitleColor(.nightSky2, for: .normal)
        setTitleColor(.sheep4, for: .disabled)
        setTitleColor(.nightSky4, for: .highlighted)
        backgroundColor = isEnabled ? .sheep2 : .sheep3
    }
    
    private func setupSheepGhost() {
        setTitleColor(.sheep1, for: .normal)
        setTitleColor(.sheep4, for: .disabled)
        setTitleColor(.sheep3, for: .highlighted)
        backgroundColor = isEnabled ? .nightSky1 : .nightSky1
        
    }
    // MARK: - Night
    private func setupNightPrimary() {
        setTitleColor(.sheep1, for: .normal)
        setTitleColor(.sheep4, for: .disabled)
        setTitleColor(.sheep1, for: .highlighted)
        setBackgroundColor(color: .nightSky1, forState: .normal)
        setBackgroundColor(color: .nightSky2, forState: .highlighted)
        setBackgroundColor(color: .sheep3, forState: .disabled)
    }
    
    private func setupNightSecondary() {
        setTitleColor(.sheep2, for: .normal)
        setTitleColor(.sheep4, for: .disabled)
        setTitleColor(.sheep2, for: .highlighted)
        setBackgroundColor(color: .nightSky3, forState: .normal)
        setBackgroundColor(color: .nightSky4, forState: .highlighted)
        setBackgroundColor(color: .sheep3, forState: .disabled)
    }
    
    private func setupNightGhost() {
        setTitleColor(.nightSky1, for: .normal)
        setTitleColor(.sheep4, for: .disabled)
        setTitleColor(.nightSky3, for: .highlighted)
        backgroundColor = .sheep1
    }
    // MARK: - ETC
    private func setupWarning() {
        setTitleColor(.sheep1, for: .normal)
        setTitleColor(.sheep4, for: .disabled)
        setTitleColor(.sheep4, for: .highlighted)
        setBackgroundColor(color: .appleRed1, forState: .normal)
        setBackgroundColor(color: .sheep3, forState: .disabled)
    }
    
    private func setupCancel() {
        setTitleColor(.sheep1, for: .normal)
        setTitleColor(.sheep4, for: .disabled)
        setTitleColor(.sheep3, for: .highlighted)
        setBackgroundColor(color: .sheep3, forState: .normal)
        setBackgroundColor(color: .sheep4, forState: .highlighted)
        setBackgroundColor(color: .sheep3, forState: .disabled)
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

extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true  // add this to maintain corner radius
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}
