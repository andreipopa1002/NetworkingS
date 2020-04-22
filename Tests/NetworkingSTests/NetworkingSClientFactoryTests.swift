import XCTest
@testable import NetworkingS

final class NetworkingSClientFactoryTests: XCTestCase {
    private var factory: ClientFactory!

    override func setUp() {
        super.setUp()

        factory = ClientFactory(session: URLSession.shared)
    }

    override func tearDown() {
        factory = nil

        super.tearDown()
    }

    func test_NetworkingClient() {
        XCTAssertTrue(factory.networkService() is NetworkService)
    }

    func test_AuthorizedService() {
        let mockedInjector = MockAPIKeyProvider()
        XCTAssertTrue(factory.authorizesService(tokenProvider: mockedInjector) is AuthorizedService)
    }
}
