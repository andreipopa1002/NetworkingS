import Foundation

public final class ClientFactory {
    let session: URLSession

    public init (session: URLSession) {
        self.session = session
    }

    public func networkService() -> NetworkServiceInterface {
        return NetworkService(with: session)
    }

    public func authorizesService(tokenProvider: AuthorizationInjectorInterface) -> AuthorizedServiceInterface {
        return AuthorizedService(
            service: networkService(),
            authorizationInjector: tokenProvider
        )
    }
}
