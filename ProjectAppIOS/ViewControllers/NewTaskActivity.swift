//
//  NewTaskViewController.swift
//  ProjectAppIOS
//
//  Created by Роман on 01.05.2020.
//  Copyright © 2020 Роман. All rights reserved.
//

import UIKit

class NewTaskActivity: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var db:DatabaseHelper = DatabaseHelper()
    var tasklist_id: Int?
    var checkUpdate: Int?
    let postmodel = TaskListModel()
    var task: Tasks?
    
    @IBOutlet var nameField: UITextField!
    
    @IBOutlet var dateField: UITextField!
    private var datePicker: UIDatePicker?
    
    @IBOutlet var priorityField: UITextField!
    
    let priorityArray = [String](arrayLiteral: "Low", "Medium", "High")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let minimumDate = Date()
        let currentDate = convertDateToString(date: Date())
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.minimumDate = minimumDate
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dateChanged));
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        dateField.inputAccessoryView = toolbar
        dateField.inputView = datePicker
        dateField.text = currentDate
        
        let priorityPicker = UIPickerView()
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
        
        let toolbarPicker = UIToolbar();
               toolbarPicker.sizeToFit()
               
               let donePButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(priorityChanged));
               let flexibleSpaceP = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
               
               toolbarPicker.setItems([flexibleSpaceP, donePButton], animated: false)
        priorityField.inputAccessoryView = toolbarPicker
        priorityField.inputView = priorityPicker
        
        if checkUpdate == 1
        {
            nameField?.text = task?.name
            dateField?.text = task?.date
            priorityField?.text = task?.priority
        }
    }
    
    @objc func dateChanged()
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateField.text = dateFormatter.string(from: datePicker!.date)
        view.endEditing(true)
    }
    
    @objc func priorityChanged()
    {
        view.endEditing(true)
    }
    
    
    @IBAction func SaveAction(_ sender: Any) {
        //db.addTask(name: "Test", done: 0, tasklist_id: 1, user_id: 1, date: "date", priority: "low", createtime: currentDate, optype: "InsTask", status: 0)
        
        if (nameField?.text!.isEmpty)! || (priorityField?.text!.isEmpty)!
        {
           Alert(message: "Value is empty")
        }
        else
        {
            if checkUpdate == 1
            {
                db.updateTask(id: task!.id, name: (nameField?.text!)!, date: (dateField?.text!)!, priority: (priorityField?.text!)!, optype: "ServerUpdatesTask", status: 0)
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
                let param = ["id": task?.id as Any,"name": (nameField?.text!)!, "done": task!.done, "tasklist_id": task?.tasklist_id as Any, "user_id": task?.user_id as Any, "date": (dateField?.text!)!, "priority": (priorityField?.text!)!, "createtime": convertCreateTimeToString(date: Date())] as [String : Any]
                postmodel.post_operation(parameters: param, kp: "ServerUpdatesTask", url: Api.URL_SERVER_TASK_UPDATES, isAlreadyexist: false)
            }
            else
            {
                db.addTask(name: (nameField?.text!)!, done: 0, tasklist_id: tasklist_id!, user_id: 1, date: (dateField?.text!)!, priority: (priorityField?.text!)!, createtime: convertCreateTimeToString(date: Date()), optype: "InsTask", status: 0)
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
                let param = ["name": (nameField?.text!)!, "done": 0, "tasklist_id": tasklist_id!, "user_id": 1, "date": (dateField?.text!)!, "priority": (priorityField?.text!)!, "createtime": convertCreateTimeToString(date: Date())] as [String : Any]
                postmodel.post_operation(parameters: param, kp: "InsTask", url: Api.URL_POST_TASK, isAlreadyexist: false)
            }
        }
        

    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return priorityArray.count
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     return priorityArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        priorityField.text = priorityArray[row]
    }

    
    func convertDateToString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let stringDate: String = dateFormatter.string(from: date as Date)
        return stringDate
    }
    
    func convertCreateTimeToString(date: Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        let stringDate: String = dateFormatter.string(from: date as Date)
        return stringDate
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
