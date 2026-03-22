import Foundation

class TodoListPresenter: TodoListPresenterProtocol {
    weak var view: TodoListViewProtocol?
    var interactor: TodoListInteractorInputProtocol?
    var router: TodoListRouterProtocol?
    
    var tasks: [TodoItem] = []
    
    func viewDidLoad() {
        interactor?.initialLoadIfNeeded()
    }
    
    func searchTasks(query: String) {
        interactor?.fetchTasks(query: query)
    }
    
    func addTask(title: String, description: String) {
        interactor?.addTask(title: title, description: description)
    }
    
    func updateTask(_ task: TodoItem, title: String, description: String, isCompleted: Bool) {
        var updatedTask = task
        updatedTask.title = title
        updatedTask.description = description
        updatedTask.isCompleted = isCompleted
        interactor?.updateTask(updatedTask)
    }
    
    func deleteTask(at index: Int) {
        let task = tasks[index]
        interactor?.deleteTask(id: task.id)
        tasks.remove(at: index)
        view?.displayTasks()
    }
}

extension TodoListPresenter: TodoListInteractorOutputProtocol {
    func tasksFetched(_ tasks: [TodoItem]) {
        self.tasks = tasks
        view?.displayTasks()
    }
    
    func tasksFetchFailed(with error: Error) {
        view?.showError(message: error.localizedDescription)
    }
}
