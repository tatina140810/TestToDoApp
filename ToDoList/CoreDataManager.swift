import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let model = NSManagedObjectModel()
        let entity = NSEntityDescription()
        entity.name = "TaskEntity"
        entity.managedObjectClassName = NSStringFromClass(TaskEntity.self)
        
        let idAttr = NSAttributeDescription()
        idAttr.name = "id"
        idAttr.attributeType = .integer64AttributeType
        idAttr.isOptional = false
        
        let titleAttr = NSAttributeDescription()
        titleAttr.name = "title"
        titleAttr.attributeType = .stringAttributeType
        titleAttr.isOptional = true
        
        let descAttr = NSAttributeDescription()
        descAttr.name = "todoDescription"
        descAttr.attributeType = .stringAttributeType
        descAttr.isOptional = true
        
        let createdAttr = NSAttributeDescription()
        createdAttr.name = "createdAt"
        createdAttr.attributeType = .dateAttributeType
        createdAttr.isOptional = true
        
        let completedAttr = NSAttributeDescription()
        completedAttr.name = "isCompleted"
        completedAttr.attributeType = .booleanAttributeType
        completedAttr.isOptional = false
        
        entity.properties = [idAttr, titleAttr, descAttr, createdAttr, completedAttr]
        model.entities = [entity]

        let container = NSPersistentContainer(name: "TaskModel", managedObjectModel: model)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
