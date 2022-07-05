//
//  Created by Alex.M on 31.05.2022.
//

import Foundation
import Combine

public enum MediaType {
    case image
    case video
}

public struct Media {
    internal let source: Source
    public let type: MediaType
}

// MARK: - Public methods for get data from MediaItem
public extension Media {

#if DEBUG
    static var random: Media {
        let randomMediaType = [MediaType.video, .image].randomElement() ?? .image
        let randomSize = (300...600).randomElement() ?? 300
        return Media(source: .url(URL(string: "https://picsum.photos/\(randomSize)")!), type: randomMediaType)
    }
#endif

    func getData() -> Future<Data?, Never> {
        return Future { promise in
            switch source {
            case .media(let media):
                Task {
                    let data = await media.source.data()
                    promise(.success(data))
                }
            case .url(let url):
                DispatchQueue.global().async {
                    do {
                        let data = try Data(contentsOf: url)
                        promise(.success(data))
                    } catch {
                        promise(.success(nil))
                    }
                }
            }
        }
    }

    func getUrl() -> Future<URL?, Never> {
        return Future { promise in
            switch source {
            case .url(let url):
                promise(.success(url))
            case .media(let media):
                media.source.getURL { url in
                    promise(.success(url))
                }
            }
        }
    }
}

// MARK: - Media+Identifiable
extension Media: Identifiable {
    public var id: String {
        switch source {
        case .url(let url):
            return url.absoluteString
        case .media(let media):
            return media.id
        }
    }
}

extension Media: Equatable {
    public static func == (lhs: Media, rhs: Media) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Inner types
extension Media {
    enum Source {
        case media(MediaModel)
        case url(URL)
    }
}
