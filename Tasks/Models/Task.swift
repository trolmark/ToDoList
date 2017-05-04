//
//  Task.swift
//  Tasks
//
//  Created by Andrew Denisov on 4/27/17.
//  Copyright © 2017 Code. All rights reserved.
//

import Foundation

enum TaskStatus {
    case completed
    case pending
    
    var opposite : TaskStatus {
        switch self {
        case .completed :  return .pending
        case .pending : return .completed
        }
    }
}

extension TaskStatus {
    init(status:Bool) {
        switch status {
        case true:
            self = .completed
        case false:
            self = .pending
        }
    }
}

struct Task {
    let identifier : String
    let name : String
    let status : TaskStatus
    let children : [Task]
}

extension Task {
    
    init?(dict : [String : Any]) {
        guard let name = dict[Keys.title] as? String,
            let status = dict[Keys.completed] as? Bool
            else {
                return nil
        }
        
        self.name = name
        self.identifier = TaskHelper.randomString(length: 7)
        
        if let children = dict[Keys.children] as? Array<[String : Any]> {
            self.children = children.flatMap { Task(dict: $0) }
            self.status = TaskHelper.fold(tasks: self.children)
        } else {
            self.children = []
            self.status = TaskStatus(status: status)
        }
    }
}


struct TaskHelper {

    static func fold(tasks:[Task]) -> TaskStatus {
        let newStatus : TaskStatus = tasks.reduce(.completed) { result, item  in
            switch item.status {
            case .pending : return .pending
            case .completed : return result
            }
        }
        return newStatus
    }
    
    // Simple generator of task identifiers
    static func randomString(length:Int) -> String {
        let charSet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var c = charSet.characters.map { String($0) }
        var s:String = ""
        for _ in (1...length) {
            s.append(c[Int(arc4random()) % c.count])
        }
        return s
    }

}


