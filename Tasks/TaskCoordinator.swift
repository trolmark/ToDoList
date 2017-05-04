//
//  TaskCoordinator.swift
//  Tasks
//
//  Created by Andrew Denisov on 4/27/17.
//  Copyright © 2017 Code. All rights reserved.
//

import Foundation


final class TaskCoordinator {
    
    weak var windowController: TaskUIFlow? {
        didSet {
            windowController?.flowDelegate = self
        }
    }
    
    fileprivate var cursor : TaskZipper
    
    init(_ generator:TaskGenerator) {
        let items = generator.parse()
        self.cursor = TaskZipper(items: items)
    }
    
    func showInitialPage() {
        DispatchQueue.main.async {
            self.windowController?.showInitialPage(items: self.cursor.currentItem.children)
        }
    }
}

extension TaskCoordinator : FlowProtocol {
    
    func didTapOn(task:Task) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.cursor.moveDown(to: task)
            self.cursor.changeStatus(to: task.status.opposite)
            self.cursor.moveUp()
            self.updateUI(with:self.cursor.currentItem.children)
        }
    }
    
    func sort() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.cursor.sort()
            self.updateUI(with: self.cursor.currentItem.children)
        }
    }
    
    func completeAll() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.cursor.changeStatus(to: .completed)
            self.updateUI(with:self.cursor.currentItem.children)
        }
    }
    
    func didTapOnDetailsFor(task:Task) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.cursor.moveDown(to: task)
            let current = self.cursor.currentItem
            
            DispatchQueue.main.async {
                self.windowController?.showDetailPage(for: current.name, items: current.children)
            }
        }
    }
    
    func didMoveBack() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.cursor.moveUp()
            self.updateUI(with: self.cursor.currentItem.children)
        }
    }
    
    func updateUI(with items:[Task]) {
        DispatchQueue.main.async {
            self.windowController?.updateCurrentController(items: items)
        }
    }
}
