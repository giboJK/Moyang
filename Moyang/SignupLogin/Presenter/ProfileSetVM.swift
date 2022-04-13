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
    @Published var birth: Date?
    
    @Published var isAddSuccess: Bool = false
    @Published var isAddingData: Bool = false
    
    init(loginService: LoginService) {
        self.loginService = loginService
    }
    
    deinit { Log.i(self) }
    
    func setUserProfile(email: String) {
        guard let birth = birth,
              let auth = UserData.shared.authType,
              let email = UserData.shared.userID?.lowercased() else {
            Log.e("Data empty")
            return
        }
        let memberDetail = MemberDetail(id: UUID().uuidString,
                                        authType: auth,
                                        memberName: name,
                                        birth: birth.toString("yyyy.MM.dd"),
                                        email: email,
                                        groupList: [],
                                        mainGroup: "",
                                        startDate: Date().toString("yyyy.MM.dd"),
                                        community: "YD",
                                        grade: 1,
                                        isPastor: false,
                                        church: nil)
        
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
