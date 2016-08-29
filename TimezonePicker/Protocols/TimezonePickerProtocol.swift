//
//  TimezonePickerProtocol.swift
//  TimezonePicker
//
//  Created by Stefan Lazarevski on 8/4/16.
//  Copyright © 2016 Stefan Lazarevski. All rights reserved.
//

import Foundation

public protocol TimeZonePicker: class {
    weak var delegate: TimeZonePickerDelegate? {get set}
}

public protocol TimeZonePickerDelegate: class {
    func timezoneSelected(timezone: NSTimeZone, displayString: String)
}