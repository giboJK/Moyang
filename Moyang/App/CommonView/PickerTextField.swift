//
//  PickerTextField.swift
//  Moyang
//
//  Created by kibo on 2022/02/26.
//

import Foundation
import SwiftUI

struct PickerTextField: UIViewRepresentable {
    
    private let textField = UITextField()
    private let pickerView = UIPickerView()
    private let helper = Helper()
    
    var data: [String]
    var placeholder: String
    
    @Binding var lastSelectedIndex: Int?
    
    func makeUIView(context: Context) -> UITextField {
        self.pickerView.delegate = context.coordinator
        self.pickerView.dataSource = context.coordinator
        
        self.textField.inputView = self.pickerView
        self.textField.textColor = .nightSky1
        self.textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.sheep4]
        )
        
        // Configure Accessory View
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "완료",
                                         style: .plain,
                                         target: self.helper,
                                         action: #selector(self.helper.doneButtonAction))
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        self.textField.inputAccessoryView = toolbar
        
        self.helper.doneButtonTapped = {
            if self.lastSelectedIndex == nil {
                self.lastSelectedIndex = 0
            }
            self.textField.resignFirstResponder()
        }
        
        return textField
    }
    
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        if let lastSelectedIndex = lastSelectedIndex {
            uiView.text = self.data[lastSelectedIndex]
        }
    }
     
    func makeCoordinator() -> Coordinator {
        return Coordinator(data: self.data) { index in
            self.lastSelectedIndex = index
        }
    }
                                         
    class Helper {
        public var doneButtonTapped: (() -> Void)?
        
        @objc func doneButtonAction() {
            self.doneButtonTapped?()
        }
    }
                                         
    class Coordinator: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
        private var data: [String]
        private var didSelectItem: ((Int) -> Void)?
        
        init(data: [String], didSelectItem: ((Int) -> Void)? = nil) {
            self.data = data
            self.didSelectItem = didSelectItem
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return data.count
        }
        
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return self.data[row]
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.didSelectItem?(row)
        }
    }
}
