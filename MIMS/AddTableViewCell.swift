//
//  AddTableViewCell.swift
//  MIMS
//
//  Created by Zachary Chandler on 4/29/16.
//  Copyright © 2016 UML Lovers. All rights reserved.
//

import UIKit

class AddTableViewCell: UITableViewCell {
    
    var delegate: AddDataTableviewDelegate?
    var indexPath: NSIndexPath!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var textFielf: UITextField!

    @IBAction func changedData(sender: AnyObject) {
        delegate?.changedWithNewValue(self.textFielf.text!, forIndexPath: self.indexPath)
        print(textFielf.text)
    }
    
    @IBAction func didBeginEditing(sender: AnyObject) {
        delegate?.beganEditingAtIndexPath(self.indexPath)
    }


    @IBOutlet weak var DataNamw: UILabel!
}

protocol AddDataTableviewDelegate {
    func changedWithNewValue(newValue: String, forIndexPath: NSIndexPath)
    func beganEditingAtIndexPath(indexPath: NSIndexPath)
}
