import Foundation
import CoreData

@objc(TaskEntity)
public class TaskEntity: NSManagedObject {
    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var todoDescription: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var isCompleted: Bool
}
