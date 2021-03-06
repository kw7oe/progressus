//
//  Parser.swift
//  Countdown
//
//  Created by Choong Kai Wern on 11/01/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import Foundation

class DateConverter {
    
    enum Format:String {
        case hour = "hour"
        case day = "day"
        case week = "week"
        case dayHour = "day hour"
    }
    
    enum Operation {
        case Single((Int) -> Int)
        case Multiple((Int) -> [Int]) // E.g. 3 Days 3 Hours
    }
    
    static let convertionFormula: Dictionary<Format, Operation> = [
        .hour: Operation.Single({ $0 / 60 / 60 }),
        .day: Operation.Single({ $0 / 60 / 60 / 24 }),
        .week: Operation.Single({ $0 / 60 / 60 / 24 / 7}),
        .dayHour: Operation.Multiple({ (input) -> [Int] in
            let hour = input / 60 / 60 % 24
            let day = input / 60 / 60 / 24
            return [day, hour]
        })
    ]
        
    /**
        Parse Time into String format.
        - Parameter time: the time you want to convert.
        - Returns: Time in String. E.g. 7:29 AM
     
     */
    class func convert(time: Date?) -> String {
        if time == nil { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: time!)
    }
    
    /**
        Convert Time(in seconds) into an array of tuples(time, unit).
     
        - Parameter time: time in seconds.
        - Parameter basedOn: The format according to `Parser.Format`
        - Returns: An array of tuples. E.g. [(time: "7", "  days  "), (time: "5", "  hours  ")]
     
        ```
        DateConverter.parseToArray(time: 28800, unit: .hour)
        ```
    */
    class func convertToArray(time: Int, basedOn format: Format) -> [(time: String, unit: String)] {
        var unit: [Int] = [0];
        var result: [(String, String)] = []
        if let operation = convertionFormula[format] {
            
            switch operation {
                
            case .Single(let function):
                unit[0] =  function(time)
                result.append(DateConverter.convert(time: unit[0], basedOn: format))
                
            case .Multiple(let function):
                unit = function(time)
                let string = format.rawValue.components(separatedBy: " ")
                
                let firstFormat = Format.init(rawValue: string[0])
                let firstResult = DateConverter.convert(time: unit[0], basedOn: firstFormat!)
                
                let secondFormat = Format.init(rawValue: string[1])
                let secondResult = DateConverter.convert(time: unit[1], basedOn: secondFormat!)
                result.append(firstResult)
                result.append(secondResult)
            }
        }
        return result
    }
    
    /**
     Convert Time into String format based on given Format.
     - Parameter time: the time you want to convert.
     - Parameter basedOn: the format
     - Returns: A Tuple of String. E.g. ("7", "  days  ")
     
     */
    class func convert(time: Int, basedOn format: Format) -> (time: String, unit: String) {
        return (String(time), String.pluralize(time, input: format.rawValue))
    }
}


