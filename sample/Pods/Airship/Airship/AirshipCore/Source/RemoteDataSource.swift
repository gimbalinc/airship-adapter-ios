
import Foundation


// NOTE: For internal use only. :nodoc:
@objc(UARemoteDataSource)
public enum RemoteDataSource: Int, Sendable, Codable, Equatable, Hashable, CaseIterable {
    case app
    case contact
}
