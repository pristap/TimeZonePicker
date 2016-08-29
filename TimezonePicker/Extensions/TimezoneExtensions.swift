//
//  TimezoneExtensions.swift
//  TimezonePicker
//
//  Created by Stefan Lazarevski on 8/1/16.
//  Copyright © 2016 Stefan Lazarevski. All rights reserved.
//

import Foundation


//MARK: - Extensions -
extension NSTimeZone {
    var formattedOffsetFromGMT: String {
        get {
            let seconds = self.secondsFromGMT
            let hours = seconds / 3600
            let minutes = abs((seconds / 60) % 60)
            var formattedTZ = ""
            if hours >= 0 {
                formattedTZ = String.localizedStringWithFormat("+%d:%02d", hours, minutes)
            } else {
                formattedTZ = String.localizedStringWithFormat("%d:%02d", hours, minutes)
            }
            return "(GMT\(formattedTZ))"
            
        }
    }
    
    var usLocalizedName: String {
        get {
          
            let localeIdentifier = "en_US"
            return self.localizedName(NSTimeZoneNameStyle.Generic, locale: NSLocale(localeIdentifier: localeIdentifier))!
        }
    }
}