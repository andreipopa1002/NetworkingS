import Foundation

final class ClientFactory {
    let session: URLSession

    init (session: URLSession) {
        self.session = session
    }

    func networkService() -> NetworkFrameworkInterface {
        return NetworkService(

    }
}
