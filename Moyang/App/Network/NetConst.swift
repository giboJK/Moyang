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
        /// post
        static let deleteUser = "/login/delete_user"
    }
    
    enum GroupAPI {
        /// post
        static let registerGroup = "/group/register_group"
        /// post
        static let fetchGroupSummary = "/group/group_summary_fetch"
        /// post
        static let fetchGroupEvent = "/group/event_fetch"
        /// post
        static let fetchMyGroupSummary = "/group/fetch_my_group_summary"
        /// post
        static let fetchGroupList = "/group/fetch_group_list"
        /// post
        static let fetchGroupDetail = "/group/fetch_group_detail"
        /// post
        static let fetchGroupMemberPrayList = "/group/fetch_member_pray_list"
        /// post
        static let fetchGroupMemberPrayDetail = "/pray/fetch_pray_detail"
        /// post
        static let exitGroup = "/group/exit_group"
        /// post
        static let joinGroup = "/group/join_group"
        /// post
        static let acceptGroup = "/group/accept_group"
    }
    
    enum PrayAPI {
        /// post
        static let addPray = "/pray/add_pray"
        static let addReply = "/pray/add_reply"
        static let addChange = "/pray/add_change"
        static let addAnswer = "/pray/add_answer"
        static let addPrayGroupInfo = "/pray/add_praygroup"
        /// post
        static let updatePray = "/pray/update_pray"
        static let updateReply = "/pray/update_reply"
        static let updateChange = "/pray/update_change"
        static let updateAnswer = "/pray/update_answer"
        /// post
        static let deletePray = "/pray/delete_pray"
        static let deleteReply = "/pray/delete_reply"
        static let deleteChange = "/pray/delete_change"
        static let deleteAnswer = "/pray/delete_answer"
        
        /// post
        static let fetchPrayList = "/pray/fetch_pray_list"
        static let fetchPrayDetail = "/pray/fetch_pray_detail"
        static let fetchMyGroupList = "/group/fetch_my_group_list"
        
        static let fetchPraySummary = "/pray/fetch_summary"
        
        // MARK: - Praying
        static let addAmen = "/pray/add_amen_record"
    }
    
    enum MediatorAPI {
        static let addReaction = "/pray/add_pray_reaction"
        
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
    
    enum NoteAPI {
        static let addCategory = "/note/add_category"
        static let updateCategory = "/note/update_category"
        static let deleteCategory = "/note/delete_category"
        static let fetchCategoryList = "/note/fetch_category_list"
        
        static let addNote = "/note/add_note"
        static let updateNote = "/note/update_note"
        static let deleteNote = "/note/delete_note"
        static let fetchNote = "/note/fetch_note"
        static let fetchNoteList = "/note/fetch_note_list"
    }
}
