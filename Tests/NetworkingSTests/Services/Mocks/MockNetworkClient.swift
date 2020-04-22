import Foundation
@testable import NetworkingS

final class MockNetworkService: NetworkServiceInterface {
    private(set) var spyRequest = [URLRequest]()
    private(set) var spyCompletion: NetworkServiceCompletion?

    func fetch(request: URLRequest, completion: @escaping NetworkServiceCompletion) {
        spyRequest.append(request)
        spyCompletion = completion
    }
}
