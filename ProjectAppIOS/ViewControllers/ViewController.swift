//
//  ViewController.swift
//  ProjectAppIOS
//
//  Created by Роман on 19.03.2020.
//  Copyright © 2020 Роман. All rights reserved.
//

import UIKit
import Network

class ViewController: UIViewController {

    var Status = false;
    let model = TaskListModel()
    var db:DatabaseHelper = DatabaseHelper()
    var psns : [TaskList] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        

        NetworkStateClass.shared.netStatusChangeHandler = {
            DispatchQueue.main.async {
                if NetworkStateClass.shared.isConnected
                {
                    if !self.Status
                    {
                        self.Status = true
                        print("Connected")
                        self.psns = self.db.getUnsyncedLists()
                        for i in self.psns {
                            let param = ["id": i.id, "name": i.name, "done": i.done, "user_id": i.user_id, "createtime": i.createtime] as [String : Any]
                            //self.model.post_operation(parameters: param, kp: "ServerUpdates", url: Api.URL_SERVERUPDATES, isAlreadyexist: true)
                        }
                        
                    }
                }
                else
                {
                    self.Status = false
                    print("Not connected")
                }
            }
        }
    }
    

    @IBOutlet var user_id: UITextField!
    
    @IBAction func findList(_ sender: Any) {
        
    }
    
}

extension ViewController: Downloadable { 
    func didReceiveData(data: Any) {
       DispatchQueue.main.sync {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "tasklistsID") as! TaskListActivity
        secondViewController.model = (data as! [TaskList])
            self.present(secondViewController, animated: true, completion: nil)
        }
    }
}
