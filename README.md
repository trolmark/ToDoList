# Tasks app

To-do list project, made as exercise. General idea - list of task with subtasks, which can be marked as done. Two-way binding of the task and subtask statuses is implemented — if we mark all subtask of parent task as done, parent task also will be marked as done.

## Architecture

[TaskCoordinator](https://github.com/trolmark/ToDoList/blob/master/Tasks/TaskCoordinator.swift)  - object, that connect presentation and core logic and can be thought as entry point. 

**UI** : 
* [TaskViewController](https://github.com/trolmark/ToDoList/blob/master/Tasks/UI/TaskViewController.swift) - table view controller, which display list of tasks
 * [TaskUIFlow](https://github.com/trolmark/ToDoList/blob/master/Tasks/UI/TaskUIFlow.swift) flow controller, which manages navigation flow between controllers (go to details of some task, etc.) 
 Purpose for flow object is to make TaskViewController completely torn away from
 environment where is presented and remove chain with all neighboring controllers
 
 **Logic**
 
 * [TaskZipper](https://github.com/trolmark/ToDoList/blob/master/Tasks/Models/TaskZipper.swift) - object, which is used for traversing and modifying data. ( https://en.wikipedia.org/wiki/Zipper_(data_structure)).
 * [TaskGenerator](https://github.com/trolmark/ToDoList/blob/master/Tasks/Models/TaskGenerator.swift)- parse and format raw data into models(Task)
