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

    func testLocalizedDescription() {
        let expectation = XCTestExpectation(description: "Test localizedDescription")
        networkUtils.get("localhost:3333/").then {(data) in
            XCTFail()
            expectation.fulfill()
        }.catch {(err) in
            let error = err as! NetworkError
            let expectedMsg = "unsupported URL"
            let expecetdCode = -1002
            let expectedDescription = "There was a Network Error with code \(expecetdCode) and a message: \(expectedMsg)"
            XCTAssertEqual(expectedMsg, error.msg)
            XCTAssertEqual(expecetdCode, error.code)
            XCTAssertEqual(expectedDescription, error.localizedDescription)
            XCTAssertEqual(expectedMsg, error.errorMessage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10.0)
    }

    func testNetworkErrorParsing() {
        let errorMessage = "There was an error!"
        let serverError = ServerError(error: errorMessage)
        let errorDict: [String: String] = serverError.errorDict
        guard let errorData = try? JSONSerialization.data(withJSONObject: errorDict, options: []),
            let errorString = String(data: errorData, encoding: .utf8) else {
            XCTFail()
            return
        }

        let errorCode = 500
        let networkError = NetworkError(msg: errorString, code: errorCode)
        XCTAssertEqual(networkError.code, errorCode)
        XCTAssertEqual(networkError.msg, errorString)
        XCTAssertEqual(networkError.errorMessage, errorMessage)
    }

    func testReachability() {
        do {
            try reachability.startNotifier()
        } catch {
            XCTFail("could not start reachability notifier")
        }
        print(reachability.description)
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

    func testReadDispatchQueue() {
        let expectation = XCTestExpectation(description: "HTTP GET request on queue")
        networkUtils.get(dispatchQueue: .global(qos: .userInitiated), "http://ip-api.com/json", ["data":"data"]).then {(data) in
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
