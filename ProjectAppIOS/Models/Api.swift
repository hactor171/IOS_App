//
//  Api.swift
//  ProjectAppIOS
//
//  Created by Роман on 11.04.2020.
//  Copyright © 2020 Роман. All rights reserved.
//

import UIKit

class Api{
    
        static let url: String = "http://192.168.64.2/ConApi/v1/Api.php?apicall"
        
        static let URL_POST_TASK: String = url + "=inserttask"
        static let URL_DELETE_TASK: String = url + "=deletetask"
        static let URL_UPDATEST_TASK: String = url + "=updatetaskstatus"
        static let URL_UPDATENAME_TASK: String = url + "=updatetaskname"
        static let URL_POST_TASKLIST: String = url + "=create_t_list"
        static let URL_UPDATE_TASKLIST: String = url + "=update_t_list"
        static let URL_DELETE_TASKLIST: String = url + "=delete_t_list"
        static let URL_SERVER_LIST_UPDATES: String = url + "=tasklistchanges"
        static let URL_SERVER_TASK_UPDATES: String = url + "=taskchanges"
        static let URL_GET_TASKS_LISTS: String = url + "=get_t_list_id&user_id="
        static let URL_GET_TASKS: String = url + "=get_tasks&tasklist_id="

}
