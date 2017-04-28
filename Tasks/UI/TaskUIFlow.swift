//
//  TaskFlowCoordinator.swift
//  Tasks
//
//  Created by Andrew Denisov on 4/27/17.
//  Copyright © 2017 Code. All rights reserved.
//

import Foundation
import UIKit

protocol FlowProtocol : class {
    func didTapOn(task:Task)
    func sort()
    func completeAll()
    func didTapOnDetailsFor(task:Task)
    func didMoveBack()
}

enum NavigationDirection {
    case back(Int)
    case forward(Int)
    
    var value : Int {
        switch self {
        case .back(let amount),
             .forward(let amount):
            return amount
        }
    }
}

private struct ToolbarButtons {
    static let completeAll = "complete all"
    static let sortByName = "sort by name"
}


/* 
 Purpose for flow object is to make taskViewController completely torn away from
 environment where is presented and remove chain with all neighboring controllers
 */

class TaskUIFlow : UINavigationController {
    
    weak var flowDelegate : FlowProtocol?
    fileprivate var direction : NavigationDirection = .back(0)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.isToolbarHidden = false
        self.delegate = self
    }
    
    func showInitialPage(items: [Task]) {
        let controller = listController(with: "Root", items:items)
        self.setViewControllers([controller], animated:false)
    }
    
    func showDetailPage(for title:String , items: [Task]) {
        let controller = listController(with: title, items: items)
        self.pushViewController(controller, animated: true)
    }
    
    func updateCurrentController(items: [Task]){
        guard let currentController = self.viewControllers.last as? TaskViewController
        else { return }
        
        let dataSource = TaskDataSource(tasks: items)
        currentController.dataSource = dataSource
    }
}

extension TaskUIFlow : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        self.direction = self.update(direction: self.direction,
                                     newCount: navigationController.viewControllers.count)
        switch self.direction {
        case .back(_):
            self.flowDelegate?.didMoveBack()
        default:
            break
        }
    }
    
    func update(direction:NavigationDirection, newCount:Int) -> NavigationDirection {
         return newCount > direction.value ? .forward(newCount) : .back(newCount)
    }
}

private extension TaskUIFlow {
    
    func toolbarButtons() -> [UIBarButtonItem] {
        
        let completeAllBtn = UIBarButtonItem(title: ToolbarButtons.completeAll,
                                             style: .plain,
                                             target: self, action: #selector(completeAll))
        
        let sortItemsBtn = UIBarButtonItem(title: ToolbarButtons.sortByName,
                                           style: .plain,
                                           target: self, action: #selector(sortItems))
        return [completeAllBtn, sortItemsBtn]
    }
    
    @objc
    func completeAll() {
        self.flowDelegate?.completeAll()
    }
    
    @objc
    func sortItems() {
        self.flowDelegate?.sort()
    }
}

private extension TaskUIFlow {

    func listController(with title:String, items: [Task] ) -> TaskViewController {
        
        let controller = TaskViewController(title:title)
        
        controller.tapOnTask = { [unowned self] task in
            self.flowDelegate?.didTapOn(task: task)
        }
        
        controller.goToDetail = { [unowned self] task in
            self.flowDelegate?.didTapOnDetailsFor(task: task)
        }
        
        let dataSource = TaskDataSource(tasks: items)
        controller.dataSource = dataSource
        
        controller.toolbarItems = self.toolbarButtons()
        
        return controller
    }
}
