//
//  DateFormatters.swift
//  Clima
//
//  Created by Don Gordon on 6/1/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import Foundation
import UIKit

class Formatters {
    
    // MARK: Data Formatters...
    let dateFormatter = DateFormatter()
    
    func fullDate(JSONDate: Double, timeZone: String) -> String {
        dateFormatter.dateFormat = "EEEE,  MMM d, yyyy  h:mm a"
        dateFormatter.timeZone = TimeZone(identifier: String(describing: timeZone))
        return dateFormatter.string(from: Date(timeIntervalSince1970: JSONDate))
    }

    func hourDate(JSONDate: Double, timeZone: String) -> String {
        dateFormatter.dateFormat = "h"
        dateFormatter.timeZone = TimeZone(identifier: String(describing: timeZone))
        
        return dateFormatter.string(from: Date(timeIntervalSince1970: JSONDate))

    }
   
    func amPmDate(JSONDate: Double, timeZone: String) -> String {
        dateFormatter.dateFormat = "a"
        dateFormatter.timeZone = TimeZone(identifier: String(describing: timeZone))
        
        return dateFormatter.string(from: Date(timeIntervalSince1970: JSONDate))
        
    }
    
//    func forecastHour(JSONDate: Double, timeZone: String) -> NSAttributedString {
//
//        dateFormatter.dateFormat = "h"
//        dateFormatter.timeZone = TimeZone(identifier: String(describing: timeZone))
//        let hour = dateFormatter.string(from: Date(timeIntervalSince1970: JSONDate))
//
//        Formatter.dateFormat = "a"
//        dateFormatter.timeZone = TimeZone(identifier: String(describing: timeZone))
//        let amPm = dateFormatter.string(from: Date(timeIntervalSince1970: JSONDate))
//
//        // Using extension
//        let formattedString = NSMutableAttributedString()
//        formattedString
//            .normal("\(hourDate(JSONDate: Double(forecast.list[interval + forecastDay].dt), timeZone: timeZone))")
//            .small(" \(amPmDate(JSONDate: Double(forecast.list[interval + forecastDay].dt), timeZone: timeZone))")
//        return formattedString
//        // Extension finished
//        
//    }
    
    func dayDate(JSONDate: Double, timeZone: String) -> String {
        dateFormatter.dateFormat = "EEEE,  MMM d"
        dateFormatter.timeZone = TimeZone(identifier: String(describing: timeZone))
        return dateFormatter.string(from: Date(timeIntervalSince1970: JSONDate))
    }
    
    
    
}

// MARK: Font Extension
extension NSMutableAttributedString {
    @discardableResult func small(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNextCondensed-Regular", size: 12)!]
        let smallString = NSMutableAttributedString(string:text, attributes: attrs)
        append(smallString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}
    
//    // MARK: Attributed String Formatter
//    func attributedHourString(hour: String) -> NSMutableString {
//
//        let attributedHourString = NSMutableAttributedString(string: hour)
//        attributedHourString.addAttribute(NSAttributedStringKey
//            .font, value: UIFont(name: "Helvetica", size: 10) as Any, range: NSRange(
//                location:3,
//                length:2))
//        let attributedHour = attributedHourString
//        return attributedHour
//    }
    
//
//    // Now change formatter to location's time zone.
//    formatter.dateFormat = "h:mm a"
//    formatter.timeZone = TimeZone(identifier: String(describing: locationTimeZone))
//    let tempSunrise = json["sys"]["sunrise"].doubleValue
//    weatherDataModel.sunrise = formatter.string(from: Date(timeIntervalSince1970: tempSunrise))
//    let tempSunset = json["sys"]["sunset"].doubleValue
//    weatherDataModel.sunset = formatter.string(from: Date(timeIntervalSince1970: tempSunset))

