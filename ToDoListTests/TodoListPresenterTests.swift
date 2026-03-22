import XCTest
@testable import ToDoList

class MockView: TodoListViewProtocol {
    var displayTasksCalled = false
    func displayTasks() { displayTasksCalled = true }
    func showError(message: String) { }
}

class MockInteractor: TodoListInteractorInputProtocol {
    var presenter: TodoListInteractorOutputProtocol?
    var fetchCalled = false
    func fetchTasks(query: String) { fetchCalled = true }
    func addTask(title: String, description: String) {}
    func updateTask(_ task: TodoItem) {}
    func deleteTask(id: Int64) {}
    func initialLoadIfNeeded() {}
}

final class TodoListPresenterTests: XCTestCase {
    func testTasksFetchedDisplaysTasks() {
        let presenter = TodoListPresenter()
        let view = MockView()
        presenter.view = view
        
        let tasks = [TodoItem(id: 1, title: "Test", description: "Desc", createdAt: Date(), isCompleted: false)]
        presenter.tasksFetched(tasks)
        
        XCTAssertTrue(view.displayTasksCalled)
        XCTAssertEqual(presenter.tasks.count, 1)
    }
}
