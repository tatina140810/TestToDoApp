import Foundation

struct TodosResponse: Codable {
    let todos: [TodoAPIModel]
    let total: Int
    let skip: Int
    let limit: Int
}

struct TodoAPIModel: Codable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

class NetworkService {
    static let shared = NetworkService()

    func fetchTodos(completion: @escaping (Result<[TodoAPIModel], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode(TodosResponse.self, from: data)
                completion(.success(decoded.todos))
            } catch let decodeError {
                completion(.failure(decodeError))
            }
        }
        task.resume()
    }
}
