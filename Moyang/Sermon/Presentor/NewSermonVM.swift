//
//  NewSermonVM.swift
//  Moyang
//
//  Created by kibo on 2022/02/06.
//

import SwiftUI
import Combine

class NewSermonVM: ObservableObject {
    var disposables = Set<AnyCancellable>()
    
    @Published var title = ""
    @Published var subtitle = ""
    @Published var bible = ""
    @Published var date = Date()
    @Published var worship = ""
    @Published var isAddSuccess = false
    @Published var groupQuestionListVM = GroupQuestionListVM()
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    
    var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }
    
    init() {
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
    
}
