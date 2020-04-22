import Foundation

extension URLRequest {
    static func jsonRequest(forUrl url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
}
