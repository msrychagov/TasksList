//
//  CDTaskItem.swift
//  TasksList
//
//  Created by Михаил Рычагов on 22.09.2025.
//

import CoreData
import Foundation

@objc(CDTaskItem)
public class CDTaskItem: NSManagedObject {
    
}

extension CDTaskItem {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDTaskItem> {
        return NSFetchRequest<CDTaskItem>(entityName: "CDTaskItem")
    }

    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var taskDescription: String?
    @NSManaged public var isDone: Bool
    @NSManaged public var date: Date

}

extension CDTaskItem : Identifiable {
    
    /// Конвертирует CoreData объект в доменную модель
    func toDomainModel() -> TaskItem {
        return TaskItem(
            id: self.id,
            title: self.title,
            details: self.taskDescription,
            isDone: self.isDone,
            date: self.date
        )
    }
    
    /// Создает CDTaskItem из доменной модели
    static func fromDomainModel(_ taskItem: TaskItem, context: NSManagedObjectContext) -> CDTaskItem {
        let cdTaskItem = CDTaskItem(context: context)
        cdTaskItem.id = taskItem.id
        cdTaskItem.title = taskItem.title
        cdTaskItem.taskDescription = taskItem.details
        cdTaskItem.isDone = taskItem.isDone
        cdTaskItem.date = taskItem.date
        return cdTaskItem
    }
    
    /// Обновляет CDTaskItem из доменной модели
    func updateFromDomainModel(_ taskItem: TaskItem) {
        self.title = taskItem.title
        self.taskDescription = taskItem.details
        self.isDone = taskItem.isDone
        // id и date не обновляем
    }
}
