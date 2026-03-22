import Foundation
import CoreData

class TodoListInteractor: TodoListInteractorInputProtocol {
    weak var presenter: TodoListInteractorOutputProtocol?
    
    private let coreDataManager = CoreDataManager.shared
    private let networkService = NetworkService.shared
    
    func initialLoadIfNeeded() {
        let hasLoaded = UserDefaults.standard.bool(forKey: "hasLoadedInitialData")
        if !hasLoaded {
            networkService.fetchTodos { [weak self] result in
                switch result {
                case .success(let apiTodos):
                    self?.coreDataManager.performBackgroundTask { context in
                        for apiTodo in apiTodos {
                            let entity = TaskEntity(context: context)
                            entity.id = Int64(apiTodo.id)
                            entity.title = apiTodo.todo
                            entity.todoDescription = ""
                            entity.isCompleted = apiTodo.completed
                            entity.createdAt = Date()
                        }
                        
                        // Save background context
                        if context.hasChanges {
                            do {
                                try context.save()
                            } catch { }
                        }
                        
                        UserDefaults.standard.set(true, forKey: "hasLoadedInitialData")
                        self?.fetchTasks(query: "")
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.presenter?.tasksFetchFailed(with: error)
                    }
                }
            }
        } else {
            fetchTasks(query: "")
        }
    }
    
    func fetchTasks(query: String) {
        coreDataManager.performBackgroundTask { [weak self] context in
            let fetchRequest = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
            if !query.isEmpty {
                fetchRequest.predicate = NSPredicate(format: "title CONTAINS[cd] %@ OR todoDescription CONTAINS[cd] %@", query, query)
            }
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            
            do {
                let entities = try context.fetch(fetchRequest)
                let items = entities.map { TodoItem(from: $0) }
                DispatchQueue.main.async {
                    self?.presenter?.tasksFetched(items)
                }
            } catch {
                DispatchQueue.main.async {
                    self?.presenter?.tasksFetchFailed(with: error)
                }
            }
        }
    }
    
    func addTask(title: String, description: String) {
        coreDataManager.performBackgroundTask { [weak self] context in
            let entity = TaskEntity(context: context)
            entity.id = Int64(Date().timeIntervalSince1970)
            entity.title = title
            entity.todoDescription = description
            entity.createdAt = Date()
            entity.isCompleted = false
            
            if context.hasChanges {
                try? context.save()
            }
            self?.fetchTasks(query: "")
        }
    }
    
    func updateTask(_ task: TodoItem) {
        coreDataManager.performBackgroundTask { [weak self] context in
            let fetchRequest = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
            fetchRequest.predicate = NSPredicate(format: "id == %lld", task.id)
            
            if let entity = try? context.fetch(fetchRequest).first {
                entity.title = task.title
                entity.todoDescription = task.description
                entity.isCompleted = task.isCompleted
                
                if context.hasChanges {
                    try? context.save()
                }
            }
            self?.fetchTasks(query: "")
        }
    }
    
    func deleteTask(id: Int64) {
        coreDataManager.performBackgroundTask { [weak self] context in
            let fetchRequest = NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
            fetchRequest.predicate = NSPredicate(format: "id == %lld", id)
            
            if let entity = try? context.fetch(fetchRequest).first {
                context.delete(entity)
                if context.hasChanges {
                    try? context.save()
                }
            }
            self?.fetchTasks(query: "")
        }
    }
}
