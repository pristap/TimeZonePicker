//
//  ViewController.swift
//  TimezonePickerExample
//
//  Created by Stefan Lazarevski on 8/29/16.
//  Copyright © 2016 Pristap. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TimeZonePickerDelegate {

    @IBOutlet weak var lblSelectedTimeszone: UILabel!
    @IBOutlet weak var lblSelectedTimezoneTime: UILabel!
    @IBOutlet weak var lblLocalTime: UILabel!
    @IBOutlet weak var selectTimezoneButton: UIButton!
    @IBAction func selectTimezoneButtonClicked(sender: AnyObject) {
        let vc = TimezonePickerViewController.fromNib()
        vc.delegate = self
        self.navigationController?.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    struct CustomTimezone {
        var timezone: NSTimeZone
        var displayName: String
        
        init (timezone: NSTimeZone, displayName: String) {
            self.timezone = timezone
            self.displayName = displayName
        }
    }
    
    var selectedTimezone: CustomTimezone? {
        didSet{
            self.lblSelectedTimeszone.text = selectedTimezone!.displayName
            self.displayTime()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.displayTime()
    }
    
    func displayTime() {
        let formatter = NSDateFormatter();
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = NSTimeZone.localTimeZone()
        let localTime = formatter.stringFromDate(NSDate())
        self.lblLocalTime.text = localTime
        
        if let tz = self.selectedTimezone {
            formatter.timeZone = tz.timezone
            let selectedTime = formatter.stringFromDate(NSDate())
            self.lblSelectedTimezoneTime.text = selectedTime
        }
        
        
    }
    
  
    func timezoneSelected(timezone: NSTimeZone, displayString: String) {
        self.selectedTimezone = CustomTimezone(timezone: timezone, displayName: displayString)
    }
}



