//
//  TaskZipper.swift
//  Tasks
//
//  Created by Andrew Denisov on 4/27/17.
//  Copyright © 2017 Code. All rights reserved.
//

import Foundation


struct TaskCrumb {
    let parentName : String
    let head: [Task]
    let tail: [Task]
}


// Simple implementation of  zipper ( not canonical)
// https://en.wikipedia.org/wiki/Zipper_(data_structure)

struct TaskZipper {
    
    private(set) var currentItem:Task
    private var breadcrumbs: [TaskCrumb] = []
    
    init(items: [Task]) {
        let rootItem = Task(name: "",
                            status: .pending,
                            children: items)
        currentItem = rootItem
    }
    
    mutating func changeStatus(to newStatus: TaskStatus) {
        self.currentItem = self.set(newStatus: newStatus,
                                    for: self.currentItem)
    }
    
    // search for name on the same level
    mutating func moveTo(task: Task)  {
        guard let latestCrumb = breadcrumbs.last else {
            return
        }
        
        let all = latestCrumb.head + latestCrumb.tail
        let (maybeNewItem, _, followingItems) = self.search(in: all,
                                                            predicate: { $0.name == task.name })
        guard let newItem = maybeNewItem else { return }
        
        breadcrumbs.removeLast()
        
        var newPrecedingItems = latestCrumb.head
        newPrecedingItems.append(currentItem)
        
        let newCrumb = TaskCrumb(parentName: latestCrumb.parentName,
                                 head: newPrecedingItems,
                                 tail: followingItems)
        currentItem = newItem
        breadcrumbs.append(newCrumb)
    }
    
    
    mutating func moveDown(to task:Task) {
        let (maybeNewItem, precedingItems, followingItems) = self.search(in: self.currentItem.children,
                                                                         predicate: { $0.name == task.name })
        guard let newItem = maybeNewItem else { return }
        
        let newCrumb = TaskCrumb(parentName: self.currentItem.name,
                                 head: precedingItems,
                                 tail: followingItems)
        currentItem = newItem
        breadcrumbs.append(newCrumb)
    }
    
    mutating func moveUp()  {
        guard let latestCrumb = breadcrumbs.last else {
            return
        }
        
        var newContents = latestCrumb.head
        newContents.append(currentItem)
        newContents.append(contentsOf:latestCrumb.tail)
        
        let newTask = Task(name: latestCrumb.parentName,
                           status: fold(tasks: newContents),
                           children: newContents)
        currentItem = newTask
        breadcrumbs.removeLast()
    }
    
    mutating func sort() {
        let currentChildren = self.currentItem.children
        let sortedChildren = currentChildren.sorted { $0.0.name < $0.1.name }
        self.currentItem = Task(name: self.currentItem.name,
                                status: self.currentItem.status,
                                children: sortedChildren)
    }
    
    mutating func delete(task:Task) {
        let filtered = self.currentItem.children.filter { $0.name != task.name }
        self.currentItem = Task(name: self.currentItem.name,
                                status: fold(tasks: filtered),
                                children: filtered)
    }
    
    mutating func add(task:Task) {
        let updated = self.currentItem.children + [task]
        self.currentItem = Task(name: self.currentItem.name,
                                status: fold(tasks: updated),
                                children: updated)
    }
}

extension TaskZipper {
    
    func set(newStatus:TaskStatus, for task:Task) -> Task {
        if task.children.isEmpty {
            return Task(name: task.name,
                        status: newStatus,
                        children: [])
        }
        
        let children = task.children.map { item in
            return set(newStatus:newStatus, for:item)
        }
        
        return Task(name: task.name,
                    status: newStatus,
                    children: children)
    }
    
    func search(in array:[Task],
                predicate: (Task) -> Bool) -> (Task?, [Task], [Task]) {
        guard let matchIndex = array.index(where:predicate)
            else {
                // no match
                return (nil, self.currentItem.children, [])
        }
        
        return (array[matchIndex],
                Array(array.prefix(matchIndex)),
                Array(array.suffix(from:matchIndex + 1)))
        
    }
}
