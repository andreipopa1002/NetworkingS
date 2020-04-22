import Foundation

public protocol AuthorizationInjectorInterface {
    func injectAuthorization(intoRequest: URLRequest) -> URLRequest
}

public enum AuthorizedServiceError: Error, Equatable {
    case unauthorized
    case networkError(Error)

    public static func == (lhs: AuthorizedServiceError, rhs: AuthorizedServiceError) -> Bool {
        switch (lhs, rhs) {
        case (.unauthorized, .unauthorized):
            return true
        case (.networkError(let lhsError), .networkError(let rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}

public typealias AuthorizedResult = Result<(data: Data?, response: URLResponse?), AuthorizedServiceError>
public typealias AuthorizedServiceCompletion = (AuthorizedResult) -> ()

public protocol AuthorizedServiceInterface {
    func fetch(request: URLRequest, completion: @escaping AuthorizedServiceCompletion)
}
