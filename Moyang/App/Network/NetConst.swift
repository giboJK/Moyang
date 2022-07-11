//
//  NetConst.swift
//  Moyang
//
//  Created by kibo on 2022/04/06.
//

import Foundation
import GoogleSignIn

class NetConst {
    /// https
    static let scheme = "http"
    /// moyang.com
    static let host = "27.96.135.152"
    /// /moyang/api/
    static let authTokenKey = "X-Moyang-Auth-Token"
    enum APIPath {
        /// post - login/registuser
        static let registUser = "/login/regist_user"
        
    }
}
