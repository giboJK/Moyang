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
    @Published var isAddSuccess = false
    @Published var groupQuestionList = [GroupQuestion]()
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    
    var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }
    
    init() {
        fetchSermonItem()
    }
    
    deinit {
        Log.i(self)
        disposables.removeAll()
    }
    
    func fetchSermonItem() {
        
    }
}
