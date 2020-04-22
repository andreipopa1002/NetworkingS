import Foundation

final class DecodingService {
    private let service: AuthorizedServiceInterface
    private let decoder: DecoderInterface

    init(
        service: AuthorizedServiceInterface,
        decoder: DecoderInterface
    ) {
        self.service = service
        self.decoder = decoder

    }
}

extension DecodingService: DecodingServiceInterface {
    func fetch<DecodableModel>(request: URLRequest, completion:@escaping DecodingServiceCompletion<DecodableModel>) where DecodableModel : Decodable {
        service.fetch(request: request) { [weak self] result in
            self?.handleNetworkResult(result: result, completion: completion)
        }
    }
}

private extension DecodingService {
    func handleNetworkResult<DecodableModel>(result: AuthorizedResult, completion: @escaping DecodingServiceCompletion<DecodableModel>) where DecodableModel: Decodable {
        switch result {
        case .success(let tuple):
            guard let data = tuple.data else {
                return completion(.success((model: nil, response: tuple.response)))
            }

            decodeModel(fromData: data, response: tuple.response, completion: completion)
        case .failure(let error):
            completion(.failure(error))
        }
    }

    func decodeModel<DecodableModel>(fromData data: Data, response: URLResponse?, completion: @escaping DecodingServiceCompletion<DecodableModel>) where DecodableModel : Decodable {
        do {
            let model = try self.decoder.decode(DecodableModel.self, from: data)
            completion(.success((model: model, response: response)))
        } catch  {
            completion(.failure(.networkError(error)))
        }
    }
}
