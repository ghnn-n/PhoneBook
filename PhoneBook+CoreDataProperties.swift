//
//  PhoneBook+CoreDataProperties.swift
//  PhoneBook
//
//  Created by 최규현 on 4/18/25.
//
//

import Foundation
import CoreData


extension PhoneBook {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhoneBook> {
        return NSFetchRequest<PhoneBook>(entityName: "PhoneBook")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: Int32
    @NSManaged public var phoneNumber: String?

}

extension PhoneBook : Identifiable {

}
