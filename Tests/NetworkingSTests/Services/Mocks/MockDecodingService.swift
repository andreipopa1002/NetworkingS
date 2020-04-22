import Foundation
@testable import NetworkingS

final class MockDecodingService: DecodingServiceInterface {
    private(set) var spyRequest = [URLRequest]()
    private(set) var spyCompletion: Any?

    func fetch<DecodableModel>(request: URLRequest, completion: @escaping DecodingServiceCompletion<DecodableModel>) where DecodableModel : Decodable {
        spyRequest.append(request)
        spyCompletion = completion
    }
}
