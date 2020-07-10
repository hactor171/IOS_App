//
//  TaskViewController.swift
//  ProjectAppIOS
//
//  Created by Роман on 01.05.2020.
//  Copyright © 2020 Роман. All rights reserved.
//

import UIKit

class TaskViewCell: UITableViewCell
{
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var ckeckButton: UIButton!
}

class TasksActivity: UITableViewController {

    var tasklist: TaskList?
    
    @IBOutlet var taskTableView: UITableView!
    let postmodel = TaskListModel()
    
    var model: [Tasks]?
    var db:DatabaseHelper = DatabaseHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.model = self.db.getTasks(tasklist_id: tasklist!.id)
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    override func viewWillAppear(_ animated: Bool) {
        reloadData()
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let _ = self.model else {
            return 0
        }
        return self.model!.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "taskid", for: indexPath) as! TaskViewCell
        let task = self.model![indexPath.row]
        
        cell.nameLabel?.text = task.name
        cell.dateLabel?.text = task.date
        
        cell.selectionStyle = .none
        
        cell.ckeckButton.tag = indexPath.row
        
        if (task.done == 0)
        {
            cell.ckeckButton.isSelected = false
        }
        else
        {
            cell.ckeckButton.isSelected = true
        }
        
        cell.ckeckButton.addTarget(self, action: #selector(self.buttonclicked(sender:)), for: .touchUpInside)
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let destination = segue.destination as? NewTaskActivity {
            destination.tasklist_id = tasklist?.id
               }
    }

    @objc func buttonclicked (sender: UIButton)
    {
        let task = model![sender.tag]
        print(task.id)
        if task.done == 0
        {
            db.taskCompleteness(id: task.id, done: 1, optype: "UpdatetTaskcCompletioStatus", status: 0)
            reloadData()
            let param = ["id": task.id, "done": 1] as [String : Any]
            postmodel.post_operation(parameters: param, kp: "UpdatetTaskcCompletioStatus", url: Api.URL_UPDATEST_TASK, isAlreadyexist: false)
            
        }
        else
        {
            db.taskCompleteness(id: task.id, done: 0, optype: "UpdatetTaskcCompletioStatus", status: 0)
            reloadData()
            let param = ["id": task.id, "done": 0] as [String : Any]
            postmodel.post_operation(parameters: param, kp: "UpdatetTaskcCompletioStatus", url: Api.URL_UPDATEST_TASK, isAlreadyexist: false)
        }        
    }
    
    
    
    func deleteTask()
    {
        db.addtmpId(id: 0, checklist: 1)
        db.deleteTask(id: 0)
        let param = ["id": 0] as [String : Any]
        self.postmodel.post_operation(parameters: param, kp: "DeleteTask", url: Api.URL_DELETE_TASK, isAlreadyexist: true)
    }
    
    func reloadData(){
    
         self.model = self.db.getTasks(tasklist_id: tasklist!.id)
         tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
          super.didReceiveMemoryWarning()
          // Dispose of any resources that can be recreated.
      }
        
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {

        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            let task = self.model![indexPath.row]
            print(task.name)
            self.db.addtmpId(id: task.id, checklist: 1)
            self.db.deleteTask(id: task.id)

            let param = ["id": task.id] as [String : Any]
            self.postmodel.post_operation(parameters: param, kp: "DeleteTask", url: Api.URL_DELETE_TASK, isAlreadyexist: true)
            self.reloadData()
        })
        deleteAction.backgroundColor = UIColor.red
        
        let editAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            let task = self.model![indexPath.row]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let secondViewController = storyboard.instantiateViewController(withIdentifier: "newtaskListID") as! NewTaskActivity
            secondViewController.task = task
            secondViewController.checkUpdate = 1
            self.navigationController?.pushViewController(secondViewController, animated: true)
        })
        editAction.backgroundColor = UIColor.gray

        return [deleteAction, editAction]
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
