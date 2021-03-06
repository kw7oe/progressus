//
//  CDRecord.swift
//  Progressus
//
//  Created by Choong Kai Wern on 11/05/2017.
//  Copyright © 2017 Choong Kai Wern. All rights reserved.
//

import UIKit
import CoreData

class CDRecord: NSManagedObject {

    // MARK: Class Function
    class func createRecord(_ challenge: Challenge, inContext context: NSManagedObjectContext) -> CDRecord {
        
        let record = CDRecord(context: context)
        record.challenge = try? CDChallenge.findOrCreateChallenge(challenge, inContext: context)
        record.startDate = NSDate(timeInterval: 0, since: challenge.date) as Date
        record.endDate = NSDate() as Date
        record.goal = Int16(challenge.goal)
        return record
        
    }
    
    var duration: Int {
        let durationInSeconds =  endDate?.timeIntervalSince(startDate! as Date)
        let result = DateConverter.convertToArray(time: Int(durationInSeconds ?? 0), basedOn: .day)
        return Int(result.first!.time) ?? 0
    }
    

    
}
