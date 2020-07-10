//
//  TaskListModel.swift
//  ProjectAppIOS
//
//  Created by Роман on 31.03.2020.
//  Copyright © 2020 Роман. All rights reserved.
//

import Foundation

struct Response: Decodable {
    var error: Bool
    var message: String
    var heroes: Bool
}

struct ListRoot: Decodable {
    var error: Bool
    var message: String
    var heroes: [TaskList]
}

struct TaskRoot: Decodable {
    var error: Bool
    var message: String
    var heroes: [Tasks]
}

struct TaskList: Decodable {
    var id: Int
    var name: String
    var done: Int
    var user_id: Int
    var createtime: String
}

struct Tasks: Decodable {
    var id: Int
    var name: String
    var done: Int
    var tasklist_id:Int
    var user_id: Int
    var date: String
    var priority:String
    var createtime: String
}

struct tmpid: Decodable {
    var id: Int
    var checklist: Int
}


class TaskListModel {
    
    weak var delegate: Downloadable?
    let networkModel = HttpOperations()
    let db = DatabaseHelper()
    
    func downloadTaskList(url: String) {
        let request = networkModel.get_request(url: url)
        networkModel.response(currentId:0,optype:"",request: request) { (data) in
            let model = try! JSONDecoder().decode(ListRoot?.self, from: data) as ListRoot?
            print(model!.heroes)
            self.delegate?.didReceiveData(data: model!.heroes as [TaskList])
        }
        
    }
    
    func downloadTasks(url: String) {
        let request = networkModel.get_request(url: url)
        networkModel.response(currentId:0,optype:"",request: request) { (data) in
            let model = try! JSONDecoder().decode(TaskRoot?.self, from: data) as TaskRoot?
            print(model!.heroes)
            //self.delegate?.didReceiveData(data: model!.heroes as [Tasks])
        }
        
    }

    func post_operation(parameters: [String: Any], kp: String, url: String, isAlreadyexist: Bool)
    {
        var id:Int = 0
        if(kp.elementsEqual("UpdatetTaskcCompletioStatus") || kp.elementsEqual("DeleteTask") || kp.elementsEqual("DeleteTaskList") || kp.elementsEqual("UpdateTaskList"))
        {
            id = parameters["id"] as! Int
        }
        
        let request = networkModel.post_request(parameters: parameters, url: url)
        networkModel.response(currentId:id,optype:kp, request: request) { (data) in
            let model = try! JSONDecoder().decode(Response?.self, from: data) as Response?
            print(model?.heroes as Any)
        }
    }
    
}
