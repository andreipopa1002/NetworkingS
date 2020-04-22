import Foundation

final class AuthorizedService {
    private let service: NetworkServiceInterface
    private let authorizationInjector: AuthorizationInjectorInterface

    init(service: NetworkServiceInterface, authorizationInjector: AuthorizationInjectorInterface) {
        self.service = service
        self.authorizationInjector = authorizationInjector
    }
}

extension AuthorizedService: AuthorizedServiceInterface {
    func fetch(request: URLRequest, completion: @escaping AuthorizedServiceCompletion) {
        let request = authorizationInjector.injectAuthorization(intoRequest: request)

        fetchAuth(request: request) { result in
            switch result {
            case .success(let tuple):
                guard
                    let urlResponse = tuple.response as? HTTPURLResponse,
                    urlResponse.statusCode != 401 else {
                        return completion(.failure(.unauthorized))
                }

                completion(.success(tuple))
            case .failure(let error):
                completion(.failure(.networkError(error)))
            }
        }
    }
}

private extension AuthorizedService {
    func fetchAuth(request: URLRequest, completion: @escaping NetworkServiceCompletion) {
        service.fetch(request: request, completion: completion)
    }
}
