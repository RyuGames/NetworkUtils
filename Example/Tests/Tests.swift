import XCTest
import NetworkUtils

class Tests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testHTTPGet() {
        let expectation = XCTestExpectation(description: "HTTP GET request")
        networkUtils.get("http://ip-api.com/json").then {(data) in
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                guard let status = json["status"] as? String else {
                    XCTFail()
                    expectation.fulfill()
                    return
                }
                XCTAssert(status == "success")
            } catch let parseError as NSError {
                XCTFail("JSON Error \(parseError.localizedDescription)")
            }
            expectation.fulfill()
        }.catch {(err) in
            let error = err as! NetworkError
            XCTFail("Error: \(error.msg)")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testHTTPGetError() {
        let expectation = XCTestExpectation(description: "HTTP GET request")
        networkUtils.get("http://iadasdkdat.com").then {(data) in
            XCTFail()
            expectation.fulfill()
        }.catch {(err) in
            let error = err as! NetworkError
            let expectedMsg = "A server with the specified hostname could not be found."
            let expecetdCode = -1003
            XCTAssertEqual(expectedMsg, error.msg)
            XCTAssertEqual(expecetdCode, error.code)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
