import Foundation

struct DescriptiveError: LocalizedError {
    let customDescription: String
    var errorDescription: String? {
        return customDescription
    }
}
