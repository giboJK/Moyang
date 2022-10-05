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
        static let registerUser = "/login/register_user"
        /// post
        static let checkExist = "/login/check_exist"
        /// post
        static let appLogin = "/login/app_login"
        /// post
        static let appInfo = "/login/appinfo_fetch"
    }
    
    enum GroupAPI {
        /// post
        static let registerGroup = "/group/register_user"
        /// post
        static let fetchGroupSummary = "/group/group_summary_fetch"
        /// post
        static let fetchGroupEvent = "/group/event_fetch"
    }
    
    enum PrayAPI {
        /// post
        static let addPray = "/pray/add_pray"
        static let addReply = "/pray/add_reply"
        static let addChange = "/pray/add_change"
        static let addAnswer = "/pray/add_answer"
        static let addReaction = "/pray/add_pray_reaction"
        static let addAmen = "/pray/add_amen_record"
        /// post
        static let updatePray = "/pray/update_pray"
        static let updateReply = "/pray/update_reply"
        /// post
        static let deletePray = "/pray/delete_pray"
        static let deleteReply = "/pray/delete_reply"
        
        /// post
        static let fetchPrayList = "/pray/fetch_pray_list"
        static let fetchPrayAll = "/pray/fetch_pray_all"
        static let fetchPray = "/pray/fetch_pray"
        
        static let searchPray = "/pray/search_pray"
        static let searchTag = "/pray/search_tag"
    }
    
    enum AlarmAPI {
        /// post
        static let addAlarm = "/alarm/add_alarm"
        static let updateAlarm = "/alarm/update_alarm"
        static let fetchAlarms = "/alarm/fetch_alarm"
        static let deleteAlarm = "/alarm/delete_alarm"
    }
    
    enum NoticeAPI {
        /// post
        static let fetchNotices = "/notice/fetch_notice"
    }
}
