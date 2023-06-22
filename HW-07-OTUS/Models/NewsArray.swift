import Foundation

public struct NewsArray: Codable, Hashable {

    public var status: String?
    public var totalResults: Double?
    public var articles: [News]?
}

