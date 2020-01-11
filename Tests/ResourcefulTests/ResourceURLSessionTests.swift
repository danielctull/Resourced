
import Resourceful
import XCTest

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class ResourceURLSessionTests: XCTestCase {

    func testSuccess() throws {
        try createFile(withContents: "Hello") { url in
            expect { completion in

                URLSession.shared.fetch(resource(url)) { result in
                    AssertSuccess(result, "Hello")
                    completion()
                }
            }
        }
    }

    func testFailure() throws {
        try createFile(withContents: "Hello") { base in
            expect { completion in

                let url = base.appendingPathComponent("ThisDoesNotExist")
                URLSession.shared.fetch(resource(url)) { result in
                    AssertFailure(result)
                    completion()
                }
            }
        }
    }
}
