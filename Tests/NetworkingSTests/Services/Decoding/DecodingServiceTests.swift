import XCTest
@testable import NetworkingS

final class DecodingServiceTests: XCTestCase {
    private var mockedAuthorizedService: MockAuthorizedService!
    private var mockedDecoder: MockDecoder!
    private var service: DecodingService!
    private let request = URLRequest(url: URL(string: "www.g.c")!)
    private var inferingResult: (Result<(model: DummyDecodable?, response: URLResponse?), AuthorizedServiceError>)?

    override func setUp() {
        super.setUp()

        mockedAuthorizedService = MockAuthorizedService()
        mockedDecoder = MockDecoder()
        service = DecodingService(service: mockedAuthorizedService, decoder: mockedDecoder)
    }

    override func tearDown() {
        mockedAuthorizedService = nil
        mockedDecoder = nil
        service = nil

        super.tearDown()
    }

    func test_GivenRequest_WhenFetch_ThenNetworkServiceFetchWithRequest() {
        service.fetch(request: request) { self.inferingResult = $0 }
        XCTAssertEqual(mockedAuthorizedService.spyFetchRequest, [request])
    }

    func test_GivenSuccessWithData_WhenFetch_ThenDecoderDecodeSameData() {
        service.fetch(request: request) { self.inferingResult = $0 }

        let stubbedData = Data()
        mockedAuthorizedService.spyCompletion?(.success((stubbedData, nil)))
        XCTAssertEqual(mockedDecoder.spyData, [stubbedData])
    }

    func test_GivenSuccessWithNilData_WhenFetch_ThenNilModel() {
        service.fetch(request: request) { self.inferingResult = $0 }
        mockedAuthorizedService.spyCompletion?(.success((nil,nil)))
        XCTAssertNil(capturedModelFromInferredResult())
    }

    func test_GivenFailureWithData_WhenFetch_ThenFailureWithSameError() {
        service.fetch(request: request) { self.inferingResult = $0 }
        mockedAuthorizedService.spyCompletion?(.failure(.unauthorized))
        XCTAssertNotNil(capturedErrorFromInferredResult())
    }

    func test_GivenDecodingFails_WhenFetch_ThenFailure() {
        service.fetch(request: request) { self.inferingResult = $0 }
        mockedDecoder.stubbedResult = .failure(DescriptiveError(customDescription: "failed to decode"))
        mockedAuthorizedService.spyCompletion?(.success((Data(), nil)))
        var capturedError: Error?
        if case .networkError(let error) = capturedErrorFromInferredResult() {
            capturedError = error
        }
        XCTAssertEqual(capturedError?.localizedDescription, "failed to decode")
    }

    func test_GivenDecodingSuccess_WhenFetch_ThenSuccessWithModel() {
        service.fetch(request: request) { self.inferingResult = $0 }
        mockedDecoder.stubbedResult = .success(DummyDecodable())
        mockedAuthorizedService.spyCompletion?(.success((Data(), nil)))

        XCTAssertNotNil(capturedModelFromInferredResult())
    }
}

private extension DecodingServiceTests {
    func capturedErrorFromInferredResult() -> AuthorizedServiceError? {
        if case.failure(let error) = self.inferingResult {
            return error
        }

        return nil
    }

    func capturedModelFromInferredResult() -> DummyDecodable? {
        if case .success(let tuple) = self.inferingResult {
            return tuple.0
        }

        return nil
    }
}

private struct DummyDecodable: Decodable { }

private class MockAuthorizedService: AuthorizedServiceInterface {
    private(set) var spyFetchRequest = [URLRequest]()
    private(set) var spyCompletion: AuthorizedServiceCompletion?

    func fetch(request: URLRequest, completion: @escaping AuthorizedServiceCompletion) {
        spyFetchRequest.append(request)
        spyCompletion = completion
    }
}
