//
//  TaskStyle.swift
//  Tasks
//
//  Created by Andrew Denisov on 4/27/17.
//  Copyright © 2017 Code. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    
    enum ImageIdentifier: String {
        case checked = "Checkbox-Checked"
        case empty = "Checkbox-Empty"
    }
    
    convenience init!(imageIdentifier: ImageIdentifier) {
        self.init(named: imageIdentifier.rawValue)
    }
}

enum Font : String {
    case regular = "AmericanTypewriter"
}

enum FontSize : CGFloat {
    case medium = 18
}

extension Font {
    func of(size:FontSize) -> UIFont {
        return UIFont(name: self.rawValue, size: size.rawValue)!
    }
}



struct TaskStyle {
    
    func textColor(for status:TaskStatus) -> UIColor {
        switch status {
        case .completed :
            return .lightGray
        case .pending :
            return .black
        }
    }
    
    func image(for status:TaskStatus) -> UIImage {
        switch status {
        case .completed :
            return UIImage(imageIdentifier: .checked)
        case .pending :
            return UIImage(imageIdentifier: .empty)
        }
    }
}
