import Foundation

public typealias DecodingResult<DecodableModel> = Result<(model: DecodableModel?, response: URLResponse?), AuthorizedServiceError>
public typealias DecodingServiceCompletion<DecodableModel> = (DecodingResult<DecodableModel>) -> ()
public protocol DecodingServiceInterface {
    func fetch<DecodableModel: Decodable>(request: URLRequest, completion: @escaping DecodingServiceCompletion<DecodableModel>)
}

