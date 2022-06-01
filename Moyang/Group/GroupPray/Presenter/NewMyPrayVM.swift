//
//  NewMyPrayVM.swift
//  Moyang
//
//  Created by kibo on 2022/04/24.
//

import SwiftUI
import Combine

class NewMyPrayVM: ObservableObject {
    private let repo: GroupRepo
    private var cancellables: Set<AnyCancellable> = []
    var groupInfo: GroupInfo?
    
    @Published var date = Date()
    @Published var isAddSuccess = false
    var name = ""
    @Published var pray = ""
    
    var viewDismissalModePublisher = PassthroughSubject<Bool, Never>()
    
    private var shouldDismissView = false {
        didSet {
            viewDismissalModePublisher.send(shouldDismissView)
        }
    }

    init(repo: GroupRepo, groupInfo: GroupInfo?) {
        self.repo = repo
        if groupInfo == nil {
            self.groupInfo = UserData.shared.groupInfo
        } else {
            self.groupInfo = groupInfo
        }
        loadMyInfo()
    }
    
    private func loadMyInfo() {
        guard let myInfo = UserData.shared.myInfo else { return }
        name = myInfo.memberName
    }
    
    func addNewPray() {
        guard let myInfo = UserData.shared.myInfo else { return }
        guard let groupInfo = groupInfo else { return }
        
        let item = GroupIndividualPray(id: UUID().uuidString,
                                       groupID: groupInfo.id,
                                       date: date.toString("yyyy-MM-dd hh:mm:ss"),
                                       pray: pray, tags: [])
        
        repo.add(item, myInfo: myInfo)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    Log.i(completion)
                case .failure(let error):
                    Log.e(error)
                }
            }) { _ in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewGroupPrayAdded"), object: nil)
                self.shouldDismissView = true
            }.store(in: &cancellables)
    }
}
