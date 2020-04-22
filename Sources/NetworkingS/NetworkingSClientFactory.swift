import Foundation

final class ClientFactory {
    let session: URLSession

    init (session: URLSession) {
        self.session = session
    }

    func networkService() -> NetworkServiceInterface {
        return NetworkService(with: session)
    }

    func authorizesService(tokenProvider: AuthorizationInjectorInterface) -> AuthorizedServiceInterface {
        return AuthorizedService(
            service: networkService(),
            authorizationInjector: tokenProvider
        )
    }
}
