import Foundation

public struct TodoItem {
    let id: Int64
    var title: String
    var description: String
    let createdAt: Date
    var isCompleted: Bool
    
    init(id: Int64, title: String, description: String, createdAt: Date, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.description = description
        self.createdAt = createdAt
        self.isCompleted = isCompleted
    }
    
    init(from entity: TaskEntity) {
        self.id = entity.id
        self.title = entity.title ?? ""
        self.description = entity.todoDescription ?? ""
        self.createdAt = entity.createdAt ?? Date()
        self.isCompleted = entity.isCompleted
    }
}
