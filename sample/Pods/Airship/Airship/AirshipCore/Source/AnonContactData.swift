/* Copyright Airship and Contributors */

import Foundation

struct AnonContactData: Codable, Sendable {
    var tags: [String: [String]]
    var attributes: [String: AirshipJSON]
    var channels: [AssociatedChannel]
    var subscriptionLists: [String: [ChannelScope]]

    var isEmpty: Bool {
        return self.attributes.isEmpty &&
        self.tags.isEmpty &&
        self.channels.isEmpty &&
        self.subscriptionLists.isEmpty
    }

    init(tags: [String : [String]], attributes: [String : AirshipJSON], channels: [AssociatedChannel], subscriptionLists: [String : [ChannelScope]]) {
        self.tags = tags
        self.attributes = attributes
        self.channels = channels
        self.subscriptionLists = subscriptionLists
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.tags = try container.decode([String : [String]].self, forKey: .tags)
        self.channels = try container.decode([AssociatedChannel].self, forKey: .channels)
        self.subscriptionLists = try container.decode([String : [ChannelScope]].self, forKey: .subscriptionLists)

        do {
            self.attributes = try container.decode([String : AirshipJSON].self, forKey: .attributes)
        } catch {
            let legacy = try? container.decode([String : JsonValue].self, forKey: .attributes)
            guard let legacy = legacy else {
                throw error
            }

            if let decoder = decoder as? JSONDecoder {
                self.attributes = try legacy.mapValues {
                    try AirshipJSON.from(
                        json: $0.jsonEncodedValue,
                        decoder: decoder
                    )
                }
            } else {
                self.attributes = try legacy.mapValues {
                    try AirshipJSON.from(
                        json: $0.jsonEncodedValue
                    )
                }
            }
        }
    }

    // Migration purposes
    fileprivate struct JsonValue : Decodable {
        let jsonEncodedValue: String?
    }
}
