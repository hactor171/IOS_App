<?php 
	require_once '../includes/DbOperation.php';
	
	$response = array();
	
	if(isset($_GET['apicall'])){
		
		switch($_GET['apicall']){

			case 'inserttask':

				$db = new DbOperation();
				$response['error'] = false; 
				$response['message'] = 'Request successfully completed';
				$response['heroes'] = $db->Insert($_POST['name'], $_POST['done'], $_POST['tasklist_id'], $_POST['user_id'], $_POST['date'], $_POST['priority'], $_POST['createtime']);
				break;

			case 'deletetask':

				$db = new DbOperation();
				$response['error'] = false; 
				$response['message'] = 'Request successfully completed';
				$response['heroes'] = $db->DeleteTask($_POST['id']);
				break;

			case 'updatetaskstatus':

				$db = new DbOperation();
				$response['error'] = false; 
				$response['message'] = 'Request successfully completed';
				$response['heroes'] = $db->UpdateStatus($_POST['id'], $_POST['done']);
				break;
			
			case 'updatetaskname':

				$db = new DbOperation();
				$response['error'] = false; 
				$response['message'] = 'Request successfully completed';
				$response['heroes'] = $db->UpdateName($_POST['id'], $_POST['name']);
				break;
			

			case 'create_t_list':

				$db = new DbOperation();
				$response['error'] = false; 
				$response['message'] = 'Request successfully completed';
				$response['heroes'] = $db->InsertTaskList($_POST['name'], $_POST['done'], $_POST['user_id'], $_POST['createtime']);
				break;


			case 'update_t_list':

				$db = new DbOperation();
				$response['error'] = false; 
				$response['message'] = 'Request successfully completed';
				$response['heroes'] = $db->UpdateTaskList($_POST['id'], $_POST['name']);
				break;

			case 'delete_t_list':
	
				$db = new DbOperation();
				$response['error'] = false; 
				$response['message'] = 'Request successfully completed';
				$response['heroes'] = $db->DeleteTaskList($_POST['id']);
					break;	
		

			case 'get_t_list':
	
				$db = new DbOperation();
				$response['error'] = false; 
				$response['message'] = 'Request successfully completed';
				$response['heroes'] = $db->GetTaskLists();
					break;
						
			case 'get_t_list_id':
	
				$db = new DbOperation();
				$response['error'] = false; 
				$response['message'] = 'Request successfully completed';
				$response['heroes'] = $db->GetTaskLists_ID($_GET['user_id']);
					break;
					
			case 'get_tasks':
	
				$db = new DbOperation();
				$response['error'] = false; 
				$response['message'] = 'Request successfully completed';
				$response['heroes'] = $db->GetTasks($_GET['tasklist_id']);
					break;

			case 'tasklistchanges':
	
				$db = new DbOperation();
				$response['error'] = false; 
				$response['message'] = 'Request successfully completed';
				$response['heroes'] = $db->TaskListChanges($_POST['id'], $_POST['name'], $_POST['done'], $_POST['user_id'], $_POST['createtime']);
				//$response['heroes'] = $db->isTaskListAlreadyExist($_POST['id']);
					break;
					
			case 'taskchanges':
	
				$db = new DbOperation();
				$response['error'] = false; 
				$response['message'] = 'Request successfully completed';
				$response['heroes'] = $db->TaskChanges($_POST['id'], $_POST['name'], $_POST['done'], $_POST['tasklist_id'], $_POST['user_id'], $_POST['date'], $_POST['priority'], $_POST['createtime']);
				//$response['heroes'] = $db->isTaskListAlreadyExist($_POST['id']);
					break;			

	}
	}else{
		$response['error'] = true; 
		$response['message'] = 'Invalid API Call';
	}

	echo json_encode($response);
