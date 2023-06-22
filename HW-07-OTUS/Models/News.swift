import Foundation

public struct News: Codable, Hashable {

    public var source: Source?
    public var author: String?
    public var title: String?
    public var description: String?
    public var url: String?
    public var urlToImage: String?
    public var publishedAt: String?
    public var content: String?
    public var imgData: Data?
}

