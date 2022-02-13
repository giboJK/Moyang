//
//  ProfileSetVM.swift
//  Moyang
//
//  Created by kibo on 2022/02/13.
//

import SwiftUI
import Combine

class ProfileSetVM: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    private let loginService: LoginService
    
    @Published var name: String = ""
    @Published var birth: String = ""
    
    @Published var isAddSuccess: Bool = false
    @Published var isAddingData: Bool = false
    
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    deinit { Log.i(self) }
    
    func setUserProfile(email: String) {
        let memberDetail = MemberDetail(id: UUID().uuidString,
                                        authType: "EMAIL",
                                        memberName: name,
                                        birth: birth,
                                        email: email,
                                        groupList: [],
                                        mainGroup: "",
                                        startDate: Date().toString("yyyy.MM.dd"),
                                        community: "YD")
        
        loginService.setUserData(memberDetail: memberDetail)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    Log.i(completion)
                case .failure(let error):
                    Log.e(error)
                }
            }) { _ in
                self.isAddSuccess = true
            }.store(in: &cancellables)
    }
}
