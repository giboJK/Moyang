//
//  GroupVM.swift
//  Moyang
//
//  Created by kibo on 2022/03/05.
//

import SwiftUI
import Combine

class GroupVM: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var newPrayAddSuccess = false
    var groupInfo: GroupInfo?
    
    init(groupInfo: GroupInfo?) {
        if groupInfo == nil {
            self.groupInfo = UserData.shared.groupInfo
        } else {
            self.groupInfo = groupInfo
        }
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.newGroupPrayAdded),
                                               name: NSNotification.Name(rawValue: "NewGroupPrayAdded"),
                                               object: nil)
    }
    
    deinit {
        Log.i(self)
        cancellables.removeAll()
    }
    
    @objc func newGroupPrayAdded(notif: NSNotification) {
        newPrayAddSuccess = true
    }
}
