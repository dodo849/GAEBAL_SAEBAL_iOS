//
//  CoreDataFunc.swift
//  GaebalSaebal
//
//  Created by 이봄이 on 2022/05/28.
//

import UIKit
import CoreData

class CoreDataFunc {

    //카테고리 fetch
    static public func fetchCategoryList() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Category")
        let result = try! context.fetch(fetchRequest)
        return result
    }
    
    //기록 fetch
    static func fetchRecordList() -> [NSManagedObject] {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Record")
        let result = try! context.fetch(fetchRequest)
        return result
    }
    
    //기록 삭제
    static func deleteRecord(categoryIdx:Int, recordIdx:IndexPath) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Record")
        // 선택된 cell의 본문 내용으로 삭제할 record 검색
        fetchRequest.predicate = NSPredicate(format: "body = %@", recordArray[categoryIdx][recordIdx.section].body)
        
        do {
                let result = try context.fetch(fetchRequest)
                let objectToDelete = result[0] as! NSManagedObject
                context.delete(objectToDelete)
                try context.save()
                return true
            } catch let error as NSError {
                print("Could not update. \(error), \(error.userInfo)")
                return false
            }
    }
    
    //카테고리 삭제
    static func deleteCategory(categoryIdx:IndexPath) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Category")
        // 선택된 cell의 본문 내용으로 삭제할 record 검색
        fetchRequest.predicate = NSPredicate(format: "categoryName = %@", categoryArray1[categoryIdx.section])
        
        do {
                let result = try context.fetch(fetchRequest)
                let objectToDelete = result[0] as! NSManagedObject
                context.delete(objectToDelete)
                try context.save()
                return true
            } catch let error as NSError {
                print("Could not update. \(error), \(error.userInfo)")
                return false
            }
    }
    
    //카테고리 entity -> array
    static func setupCategoryData(categoryList:[NSManagedObject]) {
        categoryArray1.removeAll()
        for i in 0..<categoryList.count {
            let index:NSManagedObject = categoryList[i]
            let category = index.value(forKey: "categoryName") as? String
            categoryArray1.append(category!)
        }
    }
    
    //레코드 entity -> array
    static func setupRecordData(recordList:[NSManagedObject]) {
        recordArray.removeAll()
        for _ in 0..<categoryArray1.count {
            recordArray.append([])
        }
        let minus = categoryArray1.count - recordList.count
        for i in 0..<categoryArray1.count {
            var array: [MyRecord] = []
            for j in 0..<recordList.count {
                if categoryArray1[i] == recordList[j].value(forKey: "category") as! String {
                    let category = recordList[j].value(forKey: "category") as! String
                    let body = recordList[j].value(forKey: "body") as! String
                    let tag: String? = recordList[j].value(forKey: "tag") as? String
                    let bojNumber: String? = recordList[j].value(forKey: "bojNumber") as? String
                    let bojTitle: String? = recordList[j].value(forKey: "bojTitle") as? String
                    let gitDate: String? = recordList[j].value(forKey: "gitDate") as? String
                    let gitTitle: String? = recordList[j].value(forKey: "gitTitle") as? String
                    let gitRepoName: String? = recordList[j].value(forKey: "gitRepoName") as? String
                    let gitType: String? = recordList[j].value(forKey: "gitType") as? String
                    let eventNumber: String? = recordList[j].value(forKey: "eventNumber") as? String
                    let code: String? = recordList[j].value(forKey: "code") as? String
                    let recordDate: String? = (recordList[j].value(forKey: "recordDate") as? String)
                    let image: Data? = recordList[j].value(forKey: "image") as? Data
//                    record?.image = recordList[j].value(forKey: "image") as! Data
                    let record: MyRecord? = MyRecord(category: category , body: body, tag: tag, bojNumber: bojNumber, bojTitle: bojTitle, gitDate: gitDate, gitTitle: gitTitle, gitRepoName: gitRepoName, gitType: gitType, eventNumber: eventNumber, code: code, image:image, recordDate: recordDate)
//                    print("개 잘 나오죠? \(recordList[j].value(forKey: "category"))")
//                    print(record?.category)
                    array.append(record!)

                } else {
                    continue
                }
            }
            if array.isEmpty != true {
//                recordArray.removeAll()
                recordArray.insert(array, at: i)
            }
            
            print("@여@기@봐@ \(recordArray)")
        }
    }
}
