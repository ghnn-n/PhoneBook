//
//  PhoneBookManager.swift
//  PhoneBook
//
//  Created by 최규현 on 4/22/25.
//

import CoreData
import UIKit

// MARK: - PhoneBook CoreData를 관리하는 클래스
class PhoneBookManager {
    
    private var container = NSPersistentContainer(name: PhoneBook.id)
    var phoneBook: [PhoneBook] = []
    
    init(container: NSPersistentContainer = NSPersistentContainer(name: PhoneBook.id)) {
        self.container = container
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.container = appDelegate.persistentContainer
    }
    
    // 연락처를 생성하는 메서드(C)
    func createPhoneBook(name: String, phoneNumber: String, image: Data?) {
        guard let entity = NSEntityDescription.entity(forEntityName: PhoneBook.id, in: self.container.viewContext) else { return }
        
        let newPhoneBook = NSManagedObject(entity: entity, insertInto: self.container.viewContext)
        
        // 연락처가 고유 id를 갖도록 하기 위해 NSSortDescriptor 사용
        let fetchRequest = PhoneBook.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: PhoneBook.Key.id, ascending: false)]  // false는 내림차순
        fetchRequest.fetchLimit = 1 // 생성할 최대 데이터 개수
        
        if let lastCount = try? self.container.viewContext.fetch(fetchRequest).first {
            newPhoneBook.setValue(lastCount.id + 1, forKey: PhoneBook.Key.id)   // 가장 큰 id에 1을 더한 값을 id로 지정
        } else {
            newPhoneBook.setValue(1, forKey: PhoneBook.Key.id)  // 없을 경우 1로 지정
        }
        
        newPhoneBook.setValue(name, forKey: PhoneBook.Key.name)
        newPhoneBook.setValue(phoneNumber, forKey: PhoneBook.Key.phoneNumber)
        newPhoneBook.setValue(image, forKey: PhoneBook.Key.image)
        
        do {
            try self.container.viewContext.save()
        } catch {
            print("저장 실패")
        }
    }
    
    // 연락처를 업데이트(수정)하는 메서드(U)
    func updatePhoneBook(name: String, phoneNumber: String, image: Data?) {
        
        // 해당 연락처의 id를 불러오기 위해 옵셔널 바인딩
        guard let fetchPhoneBook = AddViewController.willFetch else { return }
        
        let fetchRequest = PhoneBook.fetchRequest()
        // 해당 연락처의 id를 불러옴
        fetchRequest.predicate = NSPredicate(format: "id == %d", fetchPhoneBook.id)
        
        do {
            let result = try self.container.viewContext.fetch(fetchRequest)
            for data in result as [NSManagedObject] {
                data.setValue(name, forKey: PhoneBook.Key.name)
                data.setValue(phoneNumber, forKey: PhoneBook.Key.phoneNumber)
                data.setValue(image, forKey: PhoneBook.Key.image)
            }
            
            try self.container.viewContext.save()
            
        } catch {
            print("수정 실패")
        }
    }
    
    // 연락처를 불러오는 메서드(R)
    func fetchPhoneBook() {
        do {
            
            // 이름순으로 정렬하기 위해 SortDescriptor 사용
            let fetchRequest = PhoneBook.fetchRequest()
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: PhoneBook.Key.name, ascending: true)]
            
            self.phoneBook = try container.viewContext.fetch(fetchRequest)
            
        } catch {
            print("PhoneBook fetch failed \(error)")
        }
    }
    
    // 연락처를 삭제하는 메서드(D)
    func deletePhoneBook(id: Int16) {
        
        let fetchRequest = PhoneBook.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let result = try self.container.viewContext.fetch(fetchRequest)
            
            for data in result as [NSManagedObject] {
                self.container.viewContext.delete(data)
            }
            
            try self.container.viewContext.save()
            fetchPhoneBook()
            
        } catch {
            print("Data delete failed: \(error)")
        }
    }
    
}
