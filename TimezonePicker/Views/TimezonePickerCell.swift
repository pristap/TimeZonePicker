//
//  TimezonePickerCell.swift
//  TimezonePicker
//
//  Created by Stefan Lazarevski on 7/31/16.
//  Copyright © 2016 Stefan Lazarevski. All rights reserved.
//

import UIKit

public class TimezonePickerCell: UITableViewCell {
    
    @IBOutlet weak var tzNameLabel: UILabel!
    @IBOutlet weak var gmtOffsetLabel: UILabel!
 
    
    static func fromNib() -> UINib {
        return UINib(nibName: "TimezonePickerCell", bundle: nil)
    }
   
}
