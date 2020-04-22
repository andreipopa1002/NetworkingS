import Foundation

public protocol NetworkFrameworkInterface: AnyObject {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Swift.Void) -> URLSessionDataTask
}
extension URLSession: NetworkFrameworkInterface {}

protocol DecoderInterface: AnyObject {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}
extension JSONDecoder: DecoderInterface {}

public enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}
