//
//  MainVM.swift
//  Moyang
//
//  Created by 정김기보 on 2022/05/15.
//

import SwiftUI
import Combine
import GoogleSignIn
import Firebase

class MainVM: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    
    @Published var logoutResult: Result<Bool, Error>?
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(logoutSuccess),
                                               name: NSNotification.Name("LOGOUT_SUCCESS"), object: nil)

    }
    
    @objc func logoutSuccess() {
        Log.e("")
        logoutResult = .success(true)
        logoutResult = nil
    }
}
