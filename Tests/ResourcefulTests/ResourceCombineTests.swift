
import Resourceful
import XCTest

#if canImport(Combine)

import Combine

@available(iOS 13.0, *)
@available(OSX 10.15, *)
@available(tvOS 13.0, *)
@available(watchOS 6.0, *)
final class ResourceCombineTests: XCTestCase {

    private var cancellable: AnyCancellable?

    func testSuccess() throws {
        try createFile(withContents: "Hello") { url in
            expect { completion in

                cancellable = URLSession.shared
                    .publisher(for: resource(url))
                    .sink(receiveCompletion: { _ in completion() },
                          receiveValue: { XCTAssertEqual($0, "Hello") })
            }
        }
    }

    func testFailure() throws {
        try createFile(withContents: "Hello") { base in
            expect { completion in

                let url = base.appendingPathComponent("ThisDoesNotExist")
                cancellable = URLSession.shared
                    .publisher(for: resource(url))
                    .replaceError(with: "ERROR")
                    .sink(receiveCompletion: { _ in completion() },
                          receiveValue: { XCTAssertEqual($0, "ERROR") })
            }
        }
    }
}

#endif
