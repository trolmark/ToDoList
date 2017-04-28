//
//  TaskCell.swift
//  Tasks
//
//  Created by Andrew Denisov on 4/27/17.
//  Copyright © 2017 Code. All rights reserved.
//

import Foundation
import UIKit

class TaskCell : UITableViewCell {

    fileprivate let style = TaskStyle()
    
    func configure(with task:Task) {
        
        guard let label = self.textLabel,
            let imageHolder = self.imageView
        else  { return }
        
        label.font = Font.regular.of(size: .medium)
        label.textColor = style.textColor(for:task.status)
        imageHolder.image = style.image(for:task.status)
        imageHolder.contentMode = .scaleAspectFit
        
        label.text = task.name
        
        self.accessoryType = task.children.count > 0 ? .detailDisclosureButton : .none
    }
    
}
