//
//  CheckBox.swift
//  Moyang
//
//  Created by 정김기보 on 2022/06/21.
//

import UIKit
import RxCocoa
import RxSwift

class CheckBox: UIButton {
    // Images
    let checkedImage = Asset.Images.Common.checkFill.image.withTintColor(.sheep2)
    let uncheckedImage = Asset.Images.Common.checkEmpty.image.withTintColor(.sheep2)
    
    // Bool property
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, for: UIControl.State.normal)
            } else {
                self.setImage(uncheckedImage, for: UIControl.State.normal)
            }
        }
    }
    
    required init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base: CheckBox {
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
