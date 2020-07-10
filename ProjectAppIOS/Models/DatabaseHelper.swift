//
//  DatabaseHelper.swift
//  ProjectAppIOS
//
//  Created by Роман on 09.04.2020.
//  Copyright © 2020 Роман. All rights reserved.
//

import UIKit
import Foundation
import SQLite3

class DatabaseHelper {
    
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?
    init() {
        db = openDatabase()
        createTaskListTable()
        createTaskTable()
        createTmpIdTable()
    }
    
    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
    ///tmpid
    func createTmpIdTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS tmpid(id INTEGER, checklist INTEGER);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Task list table created.")
            } else {
                print("Task list table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func gettmpList() -> [tmpid] {
         let queryStatementString = "SELECT * FROM tmpid;"
         var queryStatement: OpaquePointer? = nil
         var psns : [tmpid] = []
         if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
             while sqlite3_step(queryStatement) == SQLITE_ROW {
                 let id = sqlite3_column_int(queryStatement, 0)
                 let checklist = sqlite3_column_int(queryStatement, 1)
                 psns.append(tmpid(id: Int(id), checklist: Int(checklist)))
                
                 print("Query Result:")
                 print("\(id) | \(checklist)")
             }
         } else {
             print("SELECT statement could not be prepared")
         }
         sqlite3_finalize(queryStatement)
         return psns
     }
    
    func addtmpId (id:Int, checklist:Int)
    {
        let insertStatementString = "INSERT INTO tmpid (id, checklist) VALUES (?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_int(insertStatement, 2, Int32(checklist))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func droptmpId(id:Int) {
        let deleteStatementStirng = "DELETE FROM tmpid WHERE id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("Delete statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    ////
    /// TaskList
    func createTaskListTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS tasklist(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR, done TINYINT, user_id INTEGER, createtime VARCHAR, optype VARCHAR, status TINYINT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Task list table created.")
            } else {
                print("Task list table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func addTaskList (name:String, done:Int, user_id:Int, createtime:String, optype:String, status:Int)
    {
        let insertStatementString = "INSERT INTO tasklist (id, name, done, user_id, createtime, optype, status) VALUES (?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(done))
            sqlite3_bind_int(insertStatement, 4, Int32(user_id))
            sqlite3_bind_text(insertStatement, 5, (createtime as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 6, (optype as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 7, Int32(status))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                //print("Successfully inserted row.")
            } else {
                //print("Could not insert row.")
            }
        } else {
            //print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func getTaskLists() -> [TaskList] {
         let queryStatementString = "SELECT * FROM tasklist;"
         var queryStatement: OpaquePointer? = nil
         var psns : [TaskList] = []
         if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
             while sqlite3_step(queryStatement) == SQLITE_ROW {
                 let id = sqlite3_column_int(queryStatement, 0)
                 let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                 let done = sqlite3_column_int(queryStatement, 2)
                 let user_id = sqlite3_column_int(queryStatement, 3)
                 let createtime = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                 let status = sqlite3_column_int(queryStatement, 6)
                 psns.append(TaskList(id: Int(id), name: name, done: Int(done), user_id: Int(user_id), createtime: createtime))
                
                 //print("Query Result:")
                 //print("\(id) | \(name) | \(done) | \(user_id) | \(createtime) | \(status)")
             }
         } else {
             print("SELECT statement could not be prepared")
         }
         sqlite3_finalize(queryStatement)
         return psns
     }
    
    func getUnsyncedLists()-> [TaskList]{
         let queryStatementString = "SELECT * FROM tasklist WHERE status = 0;"
         var queryStatement: OpaquePointer? = nil
         var psns : [TaskList] = []
         if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
             while sqlite3_step(queryStatement) == SQLITE_ROW {
                 let id = sqlite3_column_int(queryStatement, 0)
                 let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                 let done = sqlite3_column_int(queryStatement, 2)
                 let user_id = sqlite3_column_int(queryStatement, 3)
                 let createtime = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                 let status = sqlite3_column_int(queryStatement, 6)
                 psns.append(TaskList(id: Int(id), name: name, done: Int(done), user_id: Int(user_id), createtime: createtime))
                 print("Query Result:")
                 print("\(id) | \(name) | \(done) | \(user_id) | \(status)")
             }
         } else {
             print("SELECT statement could not be prepared")
         }
         sqlite3_finalize(queryStatement)
        return psns
     }
    
    func updateTaskListStatus(id:Int, status:Int) {
        let updateStatementStirng = "UPDATE tasklist SET status = ? WHERE id = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementStirng, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(status))
            sqlite3_bind_int(updateStatement, 2, Int32(id))
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("Update statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func updateTaskList(id:Int, name:String) {
        let updateStatementStirng = "UPDATE tasklist SET name = ? WHERE id = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementStirng, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 2, Int32(id))
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                //print("Successfully updated row.")
            } else {
                //print("Could not update row.")
            }
        } else {
            //print("Update statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
        
    func getLastTaskListid() -> Int{
         var id:Int = 0
         let queryStatementString = "SELECT id FROM tasklist WHERE id = (SELECT MIN(id) FROM tasklist WHERE status = 0);"
         var queryStatement: OpaquePointer? = nil
         if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
             while sqlite3_step(queryStatement) == SQLITE_ROW {
                 id = Int(sqlite3_column_int(queryStatement, 0))
            
                 print("Query Result:")
                 print("\(id)")
             }
         } else {
             print("SELECT statement could not be prepared")
         }
         sqlite3_finalize(queryStatement)
         return id
     }
    
    func getLastTaskid() -> Int{
            var id:Int = 0
            let queryStatementString = "SELECT id FROM tasks WHERE id = (SELECT MIN(id) FROM tasks WHERE status = 0);"
            var queryStatement: OpaquePointer? = nil
            if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                while sqlite3_step(queryStatement) == SQLITE_ROW {
                    id = Int(sqlite3_column_int(queryStatement, 0))
               
                    print("Query Result:")
                    print("\(id)")
                }
            } else {
                print("SELECT statement could not be prepared")
            }
            sqlite3_finalize(queryStatement)
            return id
        }
    
    func deleteTaskList(id:Int) {
        //deleteTasksByListId(tasklist_id: id)
        let deleteStatementStirng = "DELETE FROM tasklist WHERE id=?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
            } else {

            }
        } else {
        }
        //sqlite3_finalize(deleteStatement)
    }
    
    func deleteTasksByListId(tasklist_id:Int) {
        let deleteStatementStirng = "DELETE FROM tasks WHERE tasklist_id=?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(tasklist_id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("Delete statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    ///Tasks
    func createTaskTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, name VARCHAR, done TINYINT, tasklist_id INTEGER, user_id INTEGER, date VARCHAR, priority VARCHAR, createtime VARCHAR, optype VARCHAR, status TINYINT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("Task table created.")
            } else {
                print("Task table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func addTask (name:String, done:Int, tasklist_id:Int, user_id:Int, date:String, priority:String, createtime:String, optype:String, status:Int)
    {
        let insertStatementString = "INSERT INTO tasks (id, name, done, tasklist_id, user_id, date, priority, createtime, optype, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 3, Int32(done))
            sqlite3_bind_int(insertStatement, 4, Int32(tasklist_id))
            sqlite3_bind_int(insertStatement, 5, Int32(user_id))
            sqlite3_bind_text(insertStatement, 6, (date as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 7, (priority as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 8, (createtime as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 9, (optype as NSString).utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 10, Int32(status))
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func getTasks(tasklist_id:Int) -> [Tasks] {
         let queryStatementString = "SELECT * FROM tasks WHERE tasklist_id="+String(tasklist_id)
         var queryStatement: OpaquePointer? = nil
         var psns : [Tasks] = []
         if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
             while sqlite3_step(queryStatement) == SQLITE_ROW {
                 let id = sqlite3_column_int(queryStatement, 0)
                 let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                 let done = sqlite3_column_int(queryStatement, 2)
                 let tasklist_id = sqlite3_column_int(queryStatement, 3)
                 let user_id = sqlite3_column_int(queryStatement, 4)
                 let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                 let ptiority = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                 let createtime = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                psns.append(Tasks(id: Int(id), name: name, done: Int(done), tasklist_id: Int(tasklist_id), user_id: Int(user_id), date: date, priority: ptiority,  createtime: createtime))
                
                 print("Query Result:")
                 print("\(id) | \(name) | \(done) | \(tasklist_id) | \(user_id) | \(date) | \(ptiority) | \(createtime)")
             }
         } else {
             print("SELECT statement could not be prepared")
         }
         sqlite3_finalize(queryStatement)
         return psns
     }
    
    func getAllTasks() -> [Tasks] {
         let queryStatementString = "SELECT * FROM tasks"
         var queryStatement: OpaquePointer? = nil
         var psns : [Tasks] = []
         if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
             while sqlite3_step(queryStatement) == SQLITE_ROW {
                 let id = sqlite3_column_int(queryStatement, 0)
                 let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                 let done = sqlite3_column_int(queryStatement, 2)
                 let tasklist_id = sqlite3_column_int(queryStatement, 3)
                 let user_id = sqlite3_column_int(queryStatement, 4)
                 let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                 let ptiority = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                 let createtime = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                psns.append(Tasks(id: Int(id), name: name, done: Int(done), tasklist_id: Int(tasklist_id), user_id: Int(user_id), date: date, priority: ptiority,  createtime: createtime))
                
//                 print("Query Result:")
//                 print("\(id) | \(name) | \(done) | \(tasklist_id) | \(user_id) | \(date) | \(ptiority) | \(createtime)")
             }
         } else {
             print("SELECT statement could not be prepared")
         }
         sqlite3_finalize(queryStatement)
         return psns
     }
    
        func getAllIncompleteTasks() -> [Tasks] {
             let queryStatementString = "SELECT * FROM tasks WHERE done = 0"
             var queryStatement: OpaquePointer? = nil
             var psns : [Tasks] = []
             if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
                 while sqlite3_step(queryStatement) == SQLITE_ROW {
                     let id = sqlite3_column_int(queryStatement, 0)
                     let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                     let done = sqlite3_column_int(queryStatement, 2)
                     let tasklist_id = sqlite3_column_int(queryStatement, 3)
                     let user_id = sqlite3_column_int(queryStatement, 4)
                     let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                     let ptiority = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                     let createtime = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                    psns.append(Tasks(id: Int(id), name: name, done: Int(done), tasklist_id: Int(tasklist_id), user_id: Int(user_id), date: date, priority: ptiority,  createtime: createtime))
                    
    //                 print("Query Result:")
    //                 print("\(id) | \(name) | \(done) | \(tasklist_id) | \(user_id) | \(date) | \(ptiority) | \(createtime)")
                 }
             } else {
                 print("SELECT statement could not be prepared")
             }
             sqlite3_finalize(queryStatement)
             return psns
         }
        
    func getUnsyncedTasks() -> [Tasks]{
         let queryStatementString = "SELECT * FROM tasks WHERE status = 0;"
         var queryStatement: OpaquePointer? = nil
         var psns : [Tasks] = []
         if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
             while sqlite3_step(queryStatement) == SQLITE_ROW {
                  let id = sqlite3_column_int(queryStatement, 0)
                  let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                  let done = sqlite3_column_int(queryStatement, 2)
                  let tasklist_id = sqlite3_column_int(queryStatement, 3)
                  let user_id = sqlite3_column_int(queryStatement, 4)
                  let date = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                  let ptiority = String(describing: String(cString: sqlite3_column_text(queryStatement, 6)))
                  let createtime = String(describing: String(cString: sqlite3_column_text(queryStatement, 7)))
                
                 psns.append(Tasks(id: Int(id), name: name, done: Int(done), tasklist_id: Int(tasklist_id), user_id: Int(user_id), date: date, priority: ptiority,  createtime: createtime))
                 print("Query Result:")
                 print("\(id) | \(name) | \(done) | \(user_id) | \(createtime)")
             }
         } else {
             print("SELECT statement could not be prepared")
         }
         sqlite3_finalize(queryStatement)
         return psns
     }
    

    func updateTaskStatus(id:Int, status:Int) {
        let updateStatementStirng = "UPDATE tasks SET status = ? WHERE id = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementStirng, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(status))
            sqlite3_bind_int(updateStatement, 2, Int32(id))
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("Update statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func updateTask(id:Int, name:String, date:String, priority:String, optype: String, status:Int) {
        let updateStatementStirng = "UPDATE tasks SET name = ?, date = ?, priority = ?, optype = ?, status = ? WHERE id = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementStirng, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(updateStatement, 1, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 2, (date as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 3, (priority as NSString).utf8String, -1, nil)
            sqlite3_bind_text(updateStatement, 4, (optype as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 5, Int32(status))
            sqlite3_bind_int(updateStatement, 6, Int32(id))
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("Update statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func taskCompleteness(id:Int, done:Int, optype:String, status:Int) {
        let updateStatementStirng = "UPDATE tasks SET done = ?, optype = ?, status = ?  WHERE id = ?;"
        var updateStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, updateStatementStirng, -1, &updateStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(updateStatement, 1, Int32(done))
            sqlite3_bind_text(updateStatement, 2, (optype as NSString).utf8String, -1, nil)
            sqlite3_bind_int(updateStatement, 3, Int32(status))
            sqlite3_bind_int(updateStatement, 4, Int32(id))
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("Successfully updated row.")
            } else {
                print("Could not update row.")
            }
        } else {
            print("Update statement could not be prepared")
        }
        sqlite3_finalize(updateStatement)
    }
    
    func getTaskid(createtime:String){
         let queryStatementString = "SELECT id FROM tasks WHERE createtime = ?;"
         var queryStatement: OpaquePointer? = nil
         if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(queryStatement, 1, (createtime as NSString).utf8String, -1, nil)
             while sqlite3_step(queryStatement) == SQLITE_ROW {
                 let id = sqlite3_column_int(queryStatement, 0)
            
                 print("Query Result:")
                 print("\(id)")
             }
         } else {
             print("SELECT statement could not be prepared")
         }
         sqlite3_finalize(queryStatement)
     }
    
    
    func deleteTask(id:Int) {
        let deleteStatementStirng = "DELETE FROM tasks WHERE id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                //print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("Delete statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
}
