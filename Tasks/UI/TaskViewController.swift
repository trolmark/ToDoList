//
//  TaskViewController.swift
//  Tasks
//
//  Created by Andrew Denisov on 4/27/17.
//  Copyright © 2017 Code. All rights reserved.
//

import Foundation
import UIKit

class TaskViewController : UITableViewController {
    
    var tapOnTask : (Task) -> () = { _ in }
    var goToDetail : (Task) -> () = { _ in }
    
    var dataSource = TaskDataSource(tasks:[]) {
        didSet {
            self.taskDataDidUpdate()
        }
    }

    fileprivate let TaskCellIdentifier = "TaskCellIdentifier"

    
    init(title:String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.setupTableView()
    }
    
    deinit {
        // The view might outlive this view controller thanks to animations;
        // explicitly nil out its references to us to avoid crashes.
        tableView.dataSource = nil
        tableView.delegate = nil
    }
}

private extension TaskViewController {
    
    func setupTableView()  {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TaskCell.self, forCellReuseIdentifier: TaskCellIdentifier)
        tableView.layoutMargins = .zero
        tableView.separatorInset = .zero
    }
}

extension TaskViewController  {
    
    func taskDataDidUpdate() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

extension TaskViewController {
    
    override func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        if let task = self.dataSource.item(at: indexPath) {
            self.tapOnTask(task)
        }
    }
    
    override func tableView(_ tableView: UITableView,
                   accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let task = self.dataSource.item(at: indexPath) {
            self.goToDetail(task)
        }
    }
}

extension TaskViewController {
    
    override func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TaskCellIdentifier,
                                                 for: indexPath) as! TaskCell
        
        if let task = self.dataSource.item(at: indexPath) {
            cell.configure(with: task)
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.itemsCount()
    }
    
    
}
