//
//  PhoneBook+CoreDataClass.swift
//  PhoneBook
//
//  Created by 최규현 on 4/18/25.
//
//

import Foundation
import CoreData

@objc(PhoneBook)
public class PhoneBook: NSManagedObject {
    public static let id = "PhoneBook"
    
    public enum Key {
        static let id = "id"
        static let name = "name"
        static let phoneNumber = "phoneNumber"
    }
}
