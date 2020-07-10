//
//  TaskListViewController.swift
//  ProjectAppIOS
//
//  Created by Роман on 31.03.2020.
//  Copyright © 2020 Роман. All rights reserved.
//

import UIKit
import Foundation

class TaskListViewCell: UITableViewCell
{

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var cellView: UIView!

    @IBOutlet var taskCounter: UILabel!
    @IBOutlet var taskPage: UIButton!
    
}

class TaskListActivity: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var taskListTableView: UITableView!
    
    @IBOutlet var allTaskCount: UILabel!
    @IBOutlet var incTaskCount: UILabel!
    
    let button = UIButton(type: .system)
    
    var Status = false;
    
    let postmodel = TaskListModel()
    var task: [Tasks]?
    var model: [TaskList]?
    var db:DatabaseHelper = DatabaseHelper()
    var psns : [TaskList] = []
    var tsns : [Tasks] = []
    var tasksInlist : [Tasks] = []
    var allTasks : [Tasks] = []
    var incTasks : [Tasks] = []
    var tmpsns : [tmpid] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ///Create button
        self.model = self.db.getTaskLists()
        button.frame = CGRect(x: self.view.frame.width - 80, y: self.view.frame.height - 80, width: 60, height: 60)
        button.layer.cornerRadius = 30
        button.backgroundColor = .systemBlue
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        self.view.addSubview(button)
        ///Create button
        checkStatus()

        
        NetworkStateClass.shared.netStatusChangeHandler = {
            DispatchQueue.main.async {
                if NetworkStateClass.shared.isConnected
                {
                    if !self.Status
                    {
                        self.Status = true
                        print("Connected")
                        self.updateData()
                        
                    }
                }
                else
                {
                    self.Status = false
                    print("Not connected")
                }
            }
        }
        countTasks()
    
        taskListTableView.dataSource = self
        taskListTableView.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    

    
    @objc func buttonAction(_ sender:UIButton!) {
       print("Button tapped")
        addNewList()
    }

    func countTasks()
    {
        self.allTasks = self.db.getAllTasks()
        self.incTasks = self.db.getAllIncompleteTasks()
        allTaskCount.text = String(self.allTasks.count)
        incTaskCount.text = String(self.incTasks.count)
    }
    
    func checkStatus()
    {
        if NetworkStateClass.shared.isConnected
        {
            if !self.Status
            {
                self.Status = true
                print("Connected")
                //self.updateData()
            }
        }
        else
        {
            self.Status = false
            print("Not connected")
        }
    }
    
    func updateData()
    {
        self.psns = self.db.getUnsyncedLists()
        for i in self.psns {
            let param = ["id": i.id, "name": i.name, "done": i.done, "user_id": i.user_id, "createtime": i.createtime] as [String : Any]
            self.postmodel.post_operation(parameters: param, kp: "ServerUpdatesList", url: Api.URL_SERVER_LIST_UPDATES, isAlreadyexist: true)
        }
        
        self.tsns = self.db.getUnsyncedTasks()
        for i in self.tsns {
            let param = ["id": i.id, "name": i.name, "done": i.done, "tasklist_id": i.tasklist_id,"user_id": i.user_id, "date": i.date, "priority": i.priority, "createtime": i.createtime] as [String : Any]
             self.postmodel.post_operation(parameters: param, kp: "ServerUpdatesTask", url: Api.URL_SERVER_TASK_UPDATES, isAlreadyexist: true)
        }
        
        self.tmpsns = self.db.gettmpList()
        for i in self.tmpsns {
             let param = ["id": i.id] as [String : Any]
            if i.checklist == 1
            {
                self.postmodel.post_operation(parameters: param, kp: "DeleteTask", url: Api.URL_DELETE_TASK, isAlreadyexist: true)
            }
            else
            {
                self.postmodel.post_operation(parameters: param, kp: "DeleteTaskList", url: Api.URL_DELETE_TASKLIST, isAlreadyexist: true)
            }
             
        }
    }
    
    func addNewList()
    {
        let alert = UIAlertController(title: "Enter list name", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input name of list here..."
        })

        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            if (alert.textFields?.first?.text!.isEmpty)! {
                //print("empty")
            }
            else
            {
                let name = alert.textFields?.first?.text
                let createtime = self.convertDateToString(date: Date())

                self.db.addTaskList(name: name!, done: 0, user_id: 1, createtime: createtime, optype: "InsTaskList", status: 0)
                self.reloadData()
                let param = ["name": name!, "done": "0", "user_id": "1", "createtime": createtime] as [String : Any]
                self.postmodel.post_operation(parameters: param, kp: "InsTaskList", url: Api.URL_POST_TASKLIST, isAlreadyexist: false)
                
            }
        }))

        self.present(alert, animated: true)
    }
    
    
    func updateList(id:Int, oldname:String)
    {
        let alert = UIAlertController(title: "Enter list name", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input name of list here..."
            textField.text = oldname
        })

        
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in

            if (alert.textFields?.first?.text!.isEmpty)! {
                //print("empty")
            }
            else
            {
                let name = alert.textFields?.first?.text
                self.db.updateTaskList(id: id, name: name!)
                self.reloadData()
                let param = ["id": id,"name": name!] as [String : Any]
                self.postmodel.post_operation(parameters: param, kp: "UpdateTaskList", url: Api.URL_UPDATE_TASKLIST, isAlreadyexist: false)
                
            }
        }))

        self.present(alert, animated: true)
    }
    
    
    func deleteList()
    {
        db.addtmpId(id: 0, checklist: 0)
        db.deleteTasksByListId(tasklist_id: 0)
        db.deleteTaskList(id: 0)
        let param = ["id": 0] as [String : Any]
        self.postmodel.post_operation(parameters: param, kp: "DeleteTaskList", url: Api.URL_DELETE_TASKLIST, isAlreadyexist: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }

    func reloadData()
    {
        self.model = self.db.getTaskLists()
        countTasks()
        taskListTableView.reloadData()
    }
    
    func convertDateToString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let stringDate: String = dateFormatter.string(from: date as Date)
        return stringDate
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let _ = self.model else {
            return 0
        }
        return self.model!.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath : IndexPath) -> CGFloat {
        return 100
    }

     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tasklistid", for: indexPath) as! TaskListViewCell
        
        let tasklist = self.model![indexPath.row]
        cell.cellView.layer.cornerRadius = 10
        cell.nameLabel.text = tasklist.name
        cell.descriptionLabel.text = tasklist.createtime
        self.tasksInlist = self.db.getTasks(tasklist_id: tasklist.id)
        cell.taskCounter.text = String(self.tasksInlist.count)

        //cell.makeCustomText(model: tasklist)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "taskActivity", sender: self)
    }
        
//   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//            if editingStyle == .delete {
//                // delete your item here and reload table view
//            }
//    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            let tasklist = self.model![indexPath.row]
            print(tasklist.name)
            self.db.addtmpId(id: tasklist.id, checklist: 0)
            self.db.deleteTasksByListId(tasklist_id: tasklist.id)
            self.db.deleteTaskList(id: tasklist.id)
            let param = ["id": tasklist.id] as [String : Any]
            self.postmodel.post_operation(parameters: param, kp: "DeleteTaskList", url: Api.URL_DELETE_TASKLIST, isAlreadyexist: true)
            self.reloadData()
        })
        deleteAction.backgroundColor = UIColor.red
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            let tasklist = self.model![indexPath.row]
            self.updateList(id: tasklist.id, oldname: tasklist.name)
        })
        editAction.backgroundColor = UIColor.gray

        return [deleteAction, editAction]
    }
    
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? TasksActivity {
            destination.tasklist = model?[(taskListTableView.indexPathForSelectedRow!.row)]
            taskListTableView.deselectRow(at: taskListTableView.indexPathForSelectedRow!, animated: true)
               }
    }
    
    func Alert(message: String)
    {
        let alertController = UIAlertController(title: nil, message:
            message, preferredStyle: .alert)
        alertController.view.backgroundColor = UIColor.black
        alertController.view.alpha = 0.4
        alertController.view.layer.cornerRadius = 12
        
        self.present(alertController, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3){
            alertController.dismiss(animated: true)
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
          // Dispose of any resources that can be recreated.
      }
        
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
}

