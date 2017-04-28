//
//  TaskDataSource.swift
//  Tasks
//
//  Created by Andrew Denisov on 4/27/17.
//  Copyright © 2017 Code. All rights reserved.
//

import Foundation
import UIKit


// Just simple wrapper with safe methods

struct TaskDataSource {
    fileprivate let currentTasks : [Task]
    
    init(tasks:[Task]) {
        self.currentTasks = tasks
    }
}

extension TaskDataSource {
    
    func item(at indexPath:IndexPath) -> Task? {
        let index = indexPath.row
        guard currentTasks.count > index else { return nil }
 
        return currentTasks[index]
    }
    
    func itemsCount() -> Int {
        return currentTasks.count
    }
}
