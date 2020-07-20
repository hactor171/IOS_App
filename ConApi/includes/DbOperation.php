<?php

class DbOperation
{
    private $con;
 	
    function __construct()
    {
        require_once dirname(__FILE__) . '/DbConnect.php';

		$db = new DbConnect();
 
		$this->con = $db->connect();
	}
	
	function Insert($name, $done, $tasklist_id, $user_id, $date, $priority, $createtime){

		$stmt = $this->con->prepare("INSERT INTO tasks 
		(name, done, tasklist_id, user_id, date, priority, createtime) 
		VALUES (?, ?, ?, ?, ?, ?, ?)");
		$stmt->bind_param("sssssss", $name, $done, $tasklist_id, 
		$user_id, $date, $priority, $createtime);
		if($stmt->execute())
			return true; 
		return false; 
	}

	function UpdateStatus($id, $done){

		$stmt = $this->con->prepare("UPDATE tasks SET done = ? WHERE id = ?");
		$stmt->bind_param("ss", $done,$id);
			if($stmt->execute())
				return true; 
			return false; 
	}

	function UpdateName($id, $name){

		$stmt = $this->con->prepare("UPDATE tasks SET name = ? WHERE id = ?");
		$stmt->bind_param("ss", $name,$id);
			if($stmt->execute())
				return true; 
			return false; 
	}

	function DeleteTask($id){
		$stmt = $this->con->prepare("DELETE FROM tasks WHERE id=?;");
		$stmt->bind_param("s", $id);
		if($stmt->execute())
			return true;
		return false;
	}

	/*function Insert($name, $done, $tasklist_id, $user_id, $date, $priority, $createtime){

		$stmt = $this->con->prepare("INSERT INTO tasks (name, done, tasklist_id, user_id, date, priority, createtime) VALUES (?, ?, ?, ?, ?, ?, ?)");
		$stmt->bind_param("sssssss", $name, $done, $tasklist_id, $user_id, $date, $priority, $createtime);
		if($stmt->execute())
			return true; 
		return false; 
	}*/

	function InsertTaskList($name, $done, $user_id, $createtime){
		$stmt = $this->con->prepare("INSERT INTO tasklist (name, done, user_id, createtime) VALUES (?, ?, ?, ?)");
		$stmt->bind_param("siis", $name, $done, $user_id, $createtime);
		if($stmt->execute())
			return true; 
		return false; 
	}

	function UpdateTaskList($id, $name){
		$stmt = $this->con->prepare("UPDATE tasklist SET name = ? WHERE id = ?");
		$stmt->bind_param("ss", $name,$id);
			if($stmt->execute())
				return true; 
			return false; 
		}	

	function DeleteTaskList($id){
		$stmt = $this->con->prepare("DELETE t, tl  FROM tasklist tl join tasks t on tl.id = t.tasklist_id WHERE tl.id=?;");
		$stmt->bind_param("s", $id);
		if($stmt->execute())
			return true;
		return false;
	}

	function GetTaskLists(){
		$stmt = $this->con->prepare("SELECT id, name, done, user_id, createtime FROM tasklist;");
		$stmt->execute();
		$stmt->bind_result($id, $name, $done, $user_id, $createtime);

		$TaskList = array(); 

		while($stmt->fetch()){
			$TArr  = array();
			$TArr['id'] = $id; 
			$TArr['name'] = $name; 
			$TArr['done'] = $done; 
			$TArr['user_id'] = $user_id; 
			$TArr['createtime'] = $createtime; 
			array_push($TaskList, $TArr); 
		}

	return $TaskList; 
	}

	function GetTasks($tasklist_id){
		$stmt = $this->con->prepare("SELECT id, name, done, tasklist_id, user_id, date, priority, createtime FROM tasks WHERE tasklist_id=?;");
		$stmt->bind_param("i", $tasklist_id);
		$stmt->execute();
		$stmt->bind_result($id, $name, $done, $tasklist_id, $user_id, $date, $priority, $createtime);

		$TaskList = array(); 

		while($stmt->fetch()){
			$TArr  = array();
			$TArr['id'] = $id; 
			$TArr['name'] = $name; 
			$TArr['done'] = $done; 
			$TArr['tasklist_id'] = $tasklist_id; 
			$TArr['user_id'] = $user_id; 
			$TArr['date'] = $date; 
			$TArr['priority'] = $priority; 
			$TArr['createtime'] = $createtime; 
			array_push($TaskList, $TArr); 
		}

	return $TaskList; 
	}

	function GetTaskLists_ID($user_id){
		$stmt = $this->con->prepare("SELECT id, name, done, user_id, createtime FROM tasklist WHERE user_id=?;");
		$stmt->bind_param("i", $user_id);
		$stmt->execute();
		$stmt->bind_result($id, $name, $done, $user_id, $createtime);

		$TaskList = array(); 

		while($stmt->fetch()){
			$TArr  = array();
			$TArr['id'] = $id; 
			$TArr['name'] = $name;
			$TArr['done'] = $done;  
			$TArr['user_id'] = $user_id; 
			$TArr['createtime'] = $createtime; 
			array_push($TaskList, $TArr); 
		}

	return $TaskList; 
	}

	public function TaskListChanges($id, $name, $done, $user_id, $createtime){
           
		$isListExist = $this->isTaskListAlreadyExist($id);

		if($isListExist){
			$stmt = $this->con->prepare("UPDATE tasklist SET name = ?, done = ?, user_id = ?, createtime = ? WHERE id = ?");
			$stmt->bind_param("siisi", $name,$done,$user_id,$createtime,$id);
				if($stmt->execute())
					return "Row updated succsessfull"; 
				return "Error"; 	
		}else{
			
			$stmt = $this->con->prepare("INSERT INTO tasklist (name, done, user_id, createtime) VALUES (?, ?, ?, ?)");
			$stmt->bind_param("siis", $name, $done, $user_id, $createtime);
			if($stmt->execute())
				return "Row inserted succsessfull"; 
			return "Error"; 
		}
	}

	public function TaskChanges($id, $name, $done, $tasklist_id, $user_id, $date, $priority, $createtime){
           
		$isTaskExist = $this->isTaskAlreadyExist($id);

		if($isTaskExist){
			$stmt = $this->con->prepare("UPDATE tasks SET name = ?, done = ?, tasklist_id = ?, user_id = ?, date = ?, priority = ?, createtime = ? WHERE id = ?");
			$stmt->bind_param("siiisssi", $name,$done,$tasklist_id,$user_id,$date,$priority,$createtime,$id);
				if($stmt->execute())
					return "Row updated succsessfull"; 
				return "Error"; 	
		}else{
			
			$stmt = $this->con->prepare("INSERT INTO tasks (name, done, tasklist_id, user_id, date, priority, createtime) VALUES (?, ?, ?, ?, ?, ?, ?)");
			$stmt->bind_param("siiisss", $name, $done, $tasklist_id, $user_id, $date, $priority, $createtime);
			if($stmt->execute())
				return "Row inserted succsessfull"; 
			return "Error"; 
		}
	}

	function isTaskListAlreadyExist($id){
		$stmt = $this->con->prepare("SELECT id, name FROM tasklist WHERE id = ? Limit 1;");
		$stmt->bind_param("i", $id);
		$stmt->execute();

		if($stmt->fetch()){
			return true;
		}
		return false;	
	}

	function isTaskAlreadyExist($id){
		$stmt = $this->con->prepare("SELECT id, name FROM tasks WHERE id = ? Limit 1;");
		$stmt->bind_param("i", $id);
		$stmt->execute();

		if($stmt->fetch()){
			return true;
		}
		return false;	
	}
}
