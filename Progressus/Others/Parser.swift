//
//  Parser.swift
//  Countdown
//
//  Created by Choong Kai Wern on 11/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import Foundation

class Parser {
    
    struct Format {
        static let Hour = "hour"
        static let Day = "day"
        static let Week = "week"
        static let DayHour = "day hour"
    }
    
    enum Operation {
        case Single((Int) -> Int)
        case Multiple((Int) -> [Int]) // E.g. 3 Days 3 Hours
    }
    
    static let converter: Dictionary<String, Operation> = [
        Format.Hour: Operation.Single({ $0 / 60 / 60 }),
        Format.Day: Operation.Single({ $0 / 60 / 60 / 24 }),
        Format.Week: Operation.Single({ $0 / 60 / 60 / 24 / 7}),
        Format.DayHour: Operation.Multiple({ (input) -> [Int] in
            let hour = input / 60 / 60 % 24
            let day = input / 60 / 60 / 24
            return [day, hour]
        })
    ]
    
       /**
     Parse Date into String format.
     - Parameter date: the date you want to parse.
     - Returns: Date in String. E.g. Jan 17, 2017
     
     */
    class func parse(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    /**
        Parse Time into String format.
        - Parameter time: the time you want to parse.
        - Returns: Time in String. E.g. 7:29 AM
     
     */
    class func parse(time: Date?) -> String {
        if time == nil { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: time!)
    }
    
    // This method is shitty... Refactor it 
    class func parseToArray(time: Int, basedOn format: String) -> [(time: String, unit: String)] {
        var unit: [Int] = [0];
        var result: [(String, String)] = []
        if let operation = converter[format] {
            
            switch operation {
                
            case .Single(let function):
                unit[0] =  function(time)
                result.append(Parser.parse(time: unit[0], basedOn: format))
                
            case .Multiple(let function):
                unit = function(time)
                let string = format.components(separatedBy: " ")
                
                let firstFormat = string[0]
                let firstResult = Parser.parse(time: unit[0], basedOn: firstFormat)
                
                let secondFormat = string[1]
                let secondResult = Parser.parse(time: unit[1], basedOn: secondFormat)
                result.append(firstResult)
                result.append(secondResult)
            }
        }
        return result
    }
    
    /**
     Parse Time into String format based on given Format.
     - Parameter time: the time you want to parse.
     - Parameter basedOn: the format
     - Returns: A Tuple of String. E.g. ("7", "  days  ")
     
     */
    class func parse(time: Int, basedOn format: String) -> (time: String, unit: String) {
        return (String(time), String.pluralize(time, input: format))
    }
}

