//
//  User+CoreDataProperties.swift
//  iOS-ET
//
//  Created by Quy Dam on 18/5/2022.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var monthIncome: Double
    @NSManaged public var pwd: String?
    @NSManaged public var spendingLimit: Double
    @NSManaged public var userName: String?

}

extension User : Identifiable {

}
