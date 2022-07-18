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
    
    static let googleClientID = "470101284781-8r9fu7f5c5jk5184ijc8n48jlrj2jsdn.apps.googleusercontent.com"
    
    enum LoginAPI {
        /// post
        static let registUser = "/login/regist_user"
        /// post
        static let checkExist = "/login/check_exist"
        /// post
        static let appLogin = "/login/app_login"
    }
}
