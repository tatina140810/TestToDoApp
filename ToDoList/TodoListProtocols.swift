import Foundation
import UIKit

// MARK: - View
protocol TodoListViewProtocol: AnyObject {
    func displayTasks()
    func showError(message: String)
}

// MARK: - Presenter
protocol TodoListPresenterProtocol: AnyObject {
    var view: TodoListViewProtocol? { get set }
    var interactor: TodoListInteractorInputProtocol? { get set }
    var router: TodoListRouterProtocol? { get set }
    
    var tasks: [TodoItem] { get set }
    
    func viewDidLoad()
    func searchTasks(query: String)
    func addTask(title: String, description: String)
    func updateTask(_ task: TodoItem, title: String, description: String, isCompleted: Bool)
    func deleteTask(at index: Int)
}

// MARK: - Interactor Input
protocol TodoListInteractorInputProtocol: AnyObject {
    var presenter: TodoListInteractorOutputProtocol? { get set }
    
    func fetchTasks(query: String)
    func addTask(title: String, description: String)
    func updateTask(_ task: TodoItem)
    func deleteTask(id: Int64)
    func initialLoadIfNeeded()
}

// MARK: - Interactor Output
protocol TodoListInteractorOutputProtocol: AnyObject {
    func tasksFetched(_ tasks: [TodoItem])
    func tasksFetchFailed(with error: Error)
}

// MARK: - Router
protocol TodoListRouterProtocol: AnyObject {
    static func createModule() -> UIViewController
    func navigateToTaskDetails(from view: TodoListViewProtocol, for task: TodoItem)
}
