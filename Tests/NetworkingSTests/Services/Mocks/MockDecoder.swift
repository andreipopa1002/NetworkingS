import Foundation
@testable import NetworkingS

final class MockDecoder: DecoderInterface {
    var stubbedResult: Result<Decodable, DescriptiveError>?
    private(set) var spyData = [Data]()

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        spyData.append(data)

        switch stubbedResult {
        case .failure(let error):
            throw error
        case .success(let model):
            return model as! T
        default:
            throw DescriptiveError(customDescription: "mock expected result not set")
        }
    }
}
