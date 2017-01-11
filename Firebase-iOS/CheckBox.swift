//
//  CheckBox.swift
//  Firebase-iOS
//
//  Created by Jaison on 10/01/17.
//  Copyright © 2017 Hasura. All rights reserved.
//

import UIKit

@IBDesignable
class CheckBox: UIButton {
    
    var checkedView: UIView!
    let offset: CGFloat = 4
    
    @IBInspectable var isChecked: Bool = false
    @IBInspectable var checkBoxColor: UIColor = UIColor.gray
    @IBInspectable var borderColor: UIColor = UIColor.gray
    @IBInspectable var borderWidth: CGFloat = 1.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addCheckedView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addCheckedView()
    }
    
    func toggle() {
        isChecked = !isChecked
        checkedView.isHidden = !isChecked
    }
    
    func addCheckedView() {
        checkedView = UIView()
        checkedView.backgroundColor = checkBoxColor
        self.addSubview(checkedView)
    }
    
    func setChecked(checked: Bool) {
        isChecked = checked
    }
    
    override func draw(_ rect: CGRect) {
        let checkedFrame = CGRect(x: rect.minX + offset, y: rect.minY + offset, width: rect.width - (2*offset), height: rect.height - (2*offset))
        checkedView.frame = checkedFrame
        checkedView.isHidden = !isChecked
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
    }
}
