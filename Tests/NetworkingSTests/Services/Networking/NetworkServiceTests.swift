import XCTest
@testable import NetworkingS

final class NetworkServiceTests: XCTestCase {
    private var service: NetworkService!
    private var mockedFramework: MockFramework!
    private let request = URLRequest(url: URL(string:"www.a.c")!)

    override func setUp() {
        super.setUp()

        mockedFramework = MockFramework()
        service = NetworkService(with: mockedFramework)
    }

    override func tearDown() {
        mockedFramework = nil
        service = nil

        super.tearDown()
    }

    func test_WhenFetch_ThenResumeCalled() {
        let stubbedDataTask = MockURLSessionDataTask()
        mockedFramework.stubbedDataTask = stubbedDataTask
        service.fetch(request: request) { _ in }
        XCTAssertEqual(stubbedDataTask.spyResumeCallCount, 1)
    }

    func test_WhenFetch_ThenFrameworkReceiveRequest() {
        service.fetch(request: request, completion: { _ in })
        XCTAssertEqual(mockedFramework.spyRequest, [request])
    }

    func test_GivenError_WhenFetch_ThenFailureWithError() {
        let error = DescriptiveError(customDescription: "network failure")
        mockedFramework.stubbedCompletion = (nil, nil, error)
        var capturedError: Error?

        service.fetch(request: request) { result in
            if case .failure(let resultError) = result {
                capturedError = resultError
            }
        }

        XCTAssertEqual(capturedError?.localizedDescription, "network failure")
    }

    func test_GivenData_WhenFetch_ThenResultWithData() {
        let stubbedData = Data()
        mockedFramework.stubbedCompletion = (stubbedData, nil, nil)
        var capturedData: Data?

        service.fetch(request: request) { result in
            if case .success(let resultData) = result {
                capturedData = resultData.data
            }
        }

        XCTAssertEqual(capturedData, stubbedData)
    }

    func test_GivenData_WhenFetch_ThenResultWithURLResponse() {
        let stubbedUrlResponse = URLResponse(url: URL(string: "www.g.g")!, mimeType: nil, expectedContentLength: 1, textEncodingName: nil)
        mockedFramework.stubbedCompletion = (nil, stubbedUrlResponse, nil)
        var capturedURLResponse: URLResponse?

        service.fetch(request: request) { result in
            if case .success(let tuple) = result {
                capturedURLResponse = tuple.response
            }
        }

        XCTAssertEqual(capturedURLResponse, stubbedUrlResponse)
    }
}

private class MockFramework: NetworkFrameworkInterface {
    private(set) var spyRequest: [URLRequest?] = []
    var stubbedCompletion: (Data?, URLResponse?, Error?) = (nil, nil, nil)
    var stubbedDataTask = MockURLSessionDataTask()

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask {
        spyRequest.append(request)
        completionHandler(stubbedCompletion.0, stubbedCompletion.1, stubbedCompletion.2)

        return stubbedDataTask
    }
}

private class MockURLSessionDataTask: URLSessionDataTask {
    var spyResumeCallCount = 0

    override init() { }

    override func resume() {
        spyResumeCallCount += 1
    }
}
