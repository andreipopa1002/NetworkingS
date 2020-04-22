import Foundation

public typealias NetworkResult = Result<(data: Data?, response: URLResponse?), Error>
public typealias NetworkServiceCompletion = (NetworkResult) -> ()

public protocol NetworkServiceInterface {
    func fetch(request: URLRequest, completion:@escaping NetworkServiceCompletion)
}

final class NetworkService {
    private let framework: NetworkFrameworkInterface
    
    init(with framework: NetworkFrameworkInterface) {
        self.framework = framework
    }
}

extension NetworkService: NetworkServiceInterface {

    func fetch(request: URLRequest, completion:@escaping NetworkServiceCompletion) {
        let dataTask = framework.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else  {
                completion(.success((data, response)))
            }
        }
        dataTask.resume()
    }
}
