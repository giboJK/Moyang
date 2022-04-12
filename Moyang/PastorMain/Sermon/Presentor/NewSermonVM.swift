//
//  NewSermonVM.swift
//  Moyang
//
//  Created by kibo on 2022/02/06.
//

import SwiftUI
import Combine

class NewSermonVM: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    private let repo = SermonRepoImpl(service: FSServiceImpl())
    
    
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
        cancellables.removeAll()
    }
    
    func addSermon() {
        guard let userInfo = UserData.shared.myInfo else { Log.e("No userInfo"); return }
        let sermon = Sermon(title: title,
                            subtitle: subtitle,
                            bible: bible,
                            worship: worship,
                            pastor: userInfo.memberName,
                            memberID: userInfo.id,
                            date: date.toString(format: "yyyy-MM-dd"),
                            groupQuestionList: groupQuestionListVM.groupQuestionList)
        
        repo.add(sermon)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    Log.i(completion)
                case .failure(let error):
                    Log.e(error)
                }
            }) { _ in
                self.shouldDismissView = true
            }.store(in: &cancellables)
    }
    
}
