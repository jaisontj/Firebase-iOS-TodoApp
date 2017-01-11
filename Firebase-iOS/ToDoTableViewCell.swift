//
//  ToDoTableViewCell.swift
//  Firebase-iOS
//
//  Created by Jaison on 11/01/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import UIKit
class ToDoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var checkBox: CheckBox!
    @IBOutlet weak var label: UILabel!
    
    func setUpCell(isChecked: Bool, description: String) {
        checkBox.setChecked(checked: isChecked)
        label.text = description
        handleStrikethrough()
    }
    
    func toggle() {
        checkBox.toggle()
        handleStrikethrough()
    }
    
    func handleStrikethrough() {
        if checkBox.isChecked {
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: label.text!)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            label.attributedText = attributeString
        }
    }
    
}
