import XCTest

class Tests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCreate() {
        let expectation = XCTestExpectation(description: "HTTP PUT request fail")
        networkUtils.post("http://ip-api.com/json", ["data":"data"]).then {(data) in
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

    func testDeleteError() {
        let expectation = XCTestExpectation(description: "HTTP PUT request fail")
        networkUtils.delete("http://ip-api.com/json", ["data":"data"]).then {(data) in
            XCTFail()
            expectation.fulfill()
        }.catch {(err) in
            let error = err as! NetworkError
            let expectedMsg = "Method Not Allowed"
            let expectedCode = 405
            XCTAssertTrue(error.msg.starts(with: expectedMsg))
            XCTAssertEqual(expectedCode, error.code)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testRead() {
        let expectation = XCTestExpectation(description: "HTTP GET request")
        networkUtils.get("http://ip-api.com/json", ["data":"data"]).then {(data) in
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

    func testReadError() {
        let expectation = XCTestExpectation(description: "HTTP GET request fail")
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

    func testRetryWithError() {
        let expectation = XCTestExpectation(description: "Test retry with error")
        networkUtils.testing = true
        networkUtils.get("http://iadasdkdat.com").then {(data) in
            XCTFail()
            networkUtils.testing = false
            expectation.fulfill()
        }.catch {(err) in
            let error = err as! NetworkError
            let expectedMsg = "A server with the specified hostname could not be found."
            let expecetdCode = -1003
            XCTAssertEqual(expectedMsg, error.msg)
            XCTAssertEqual(expecetdCode, error.code)
            networkUtils.testing = false
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testUpdateError() {
        let expectation = XCTestExpectation(description: "HTTP PUT request fail")
        networkUtils.put("http://ip-api.com/json", ["data":"data"]).then {(data) in
            XCTFail()
            expectation.fulfill()
        }.catch {(err) in
            let error = err as! NetworkError
            let expectedMsg = "Method Not Allowed"
            let expectedCode = 405
            XCTAssertTrue(error.msg.starts(with: expectedMsg))
            XCTAssertEqual(expectedCode, error.code)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }
}
