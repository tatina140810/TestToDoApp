import UIKit

class TodoListRouter: TodoListRouterProtocol {
    static func createModule() -> UIViewController {
        let view = TodoListViewController()
        let presenter: TodoListPresenterProtocol & TodoListInteractorOutputProtocol = TodoListPresenter()
        let interactor: TodoListInteractorInputProtocol = TodoListInteractor()
        let router: TodoListRouterProtocol = TodoListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    func navigateToTaskDetails(from view: TodoListViewProtocol, for task: TodoItem) {
        // Navigation logic if needed
    }
}
