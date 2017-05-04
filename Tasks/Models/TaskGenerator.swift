//
//  TaskResource.swift
//  Tasks
//
//  Created by Andrew Denisov on 4/27/17.
//  Copyright © 2017 Code. All rights reserved.
//

import Foundation


struct Keys {
    static let title  = "title"
    static let completed = "completed"
    static let children = "children"
}

struct TaskGenerator {
    
    fileprivate let tasks = [
        [Keys.title: "Buy milk", Keys.completed : false],
        [Keys.title: "Pay rent", Keys.completed : false],
        [Keys.title: "Change tires", Keys.completed : false],
        [Keys.title: "Sleep", Keys.completed : false,
            Keys.children : [
                [Keys.title: "Find a bed", Keys.completed : true],
                [Keys.title: "Lie down", Keys.completed : true],
                [Keys.title: "Close eyes", Keys.completed : true],
                [Keys.title: "Wait", Keys.completed : false,
                    Keys.children : [
                        [Keys.title: "Find a bed", Keys.completed : true],
                        [Keys.title: "Lie down", Keys.completed : true],
                    ]
                ],
                [Keys.title: "Dance", Keys.completed : false],
            ]
        ]
    ]
    
    func parse() -> [Task] {
        return tasks.flatMap { Task(dict: $0) }
    }
}

