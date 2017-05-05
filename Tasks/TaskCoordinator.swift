//
//  TaskCoordinator.swift
//  Tasks
//
//  Created by Andrew Denisov on 4/27/17.
//  Copyright © 2017 Code. All rights reserved.
//

import Foundation

/*
 Purpose for coordinator is to make one point of truth for data
 */

final class TaskCoordinator {
    
    weak var windowController: TaskUIFlow? {
        didSet {
            windowController?.flowDelegate = self
        }
    }
    
    fileprivate var queue : DispatchQueue
    fileprivate var cursor : TaskZipper
    fileprivate var currentItems : [Task] {
        return self.cursor.currentItem.children
    }
    
    init(_ generator:TaskGenerator) {
        let items = generator.parse()
        self.cursor = TaskZipper(items: items)
        self.queue = DispatchQueue(label: "com.todoList.queue",
                                   qos : .userInteractive)
    }
    
    func showInitialPage() {
        DispatchQueue.main.async {
            self.windowController?.showInitialPage(items: self.currentItems)
        }
    }
}

extension TaskCoordinator : FlowProtocol {
    
    func didTapOn(task:Task) {
        
        self.queue.async {
            self.cursor.moveDown(to: task)
            self.cursor.changeStatus(to: task.status.opposite)
            self.cursor.moveUp()
            self.updateUI(with:self.currentItems)
        }
    }
    
    func sort() {
        self.queue.async {
            self.cursor.sort()
            self.updateUI(with: self.currentItems)
        }
    }
    
    func completeAll() {
        self.queue.async {
            self.cursor.changeStatus(to: .completed)
            self.updateUI(with:self.currentItems)
        }
    }
    
    func didTapOnDetailsFor(task:Task) {
        
        self.queue.async {
            self.cursor.moveDown(to: task)
            let current = self.cursor.currentItem
            
            DispatchQueue.main.async {
                self.windowController?.showDetailPage(for: current.name, items: current.children)
            }
        }
    }
    
    func didMoveBack() {
        self.queue.async {
            self.cursor.moveUp()
            self.updateUI(with: self.currentItems)
        }
    }
    
    func didAddSubtask(_ task : Task) {
        self.cursor.add(task: task)
    }
    
    func didRemoveSubtask(_ task: Task) {
        self.cursor.delete(task: task)
    }
    
    
}

private extension TaskCoordinator {
    
    func updateUI(with items:[Task]) {
        DispatchQueue.main.async {
            self.windowController?.updateCurrentController(items: items)
        }
    
    }
}
