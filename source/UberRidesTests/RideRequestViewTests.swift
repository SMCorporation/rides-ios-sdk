//
//  RideRequestViewTests.swift
//  UberRides
//
//  Copyright © 2016 Uber Technologies, Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import XCTest
import WebKit
@testable import UberRides

class RideRequestViewTests: XCTestCase {
    var expectation: XCTestExpectation!
    var error: NSError?
    let timeout: TimeInterval = 10
    
    override func setUp() {
        super.setUp()
        Configuration.restoreDefaults()
        Configuration.plistName = "testInfo"
        Configuration.bundle = Bundle(forClass: self.dynamicType)
        Configuration.setSandboxEnabled(true)
    }
    
    override func tearDown() {
        Configuration.restoreDefaults()
        super.tearDown()
    }
    
    /**
     Test that access token expiration is routed to delegate.
     */
    func testAccessTokenExpired() {
        expectation = self.expectation(withDescription: "access token expired delegate call")
        let view = RideRequestView(rideParameters: RideParametersBuilder().build())
        view.delegate = self
        let request = URLRequest(url: URL(string: "uberConnect://oauth#error=unauthorized")!)
        view.webView.loadRequest(request)
        
        waitForExpectations(withTimeout: timeout, handler: { error in
            XCTAssertNil(error)
        })
    }
    
    /**
     Test the an unknown error message is routed to delegate.
     */
    func testUnkownError() {
        expectation = self.expectation(withDescription: "unknown error delegate call")
        let view = RideRequestView()
        view.delegate = self
        let request = URLRequest(url: URL(string: "uberConnect://oauth#error=on_fire")!)
        view.webView.loadRequest(request)
        
        waitForExpectations(withTimeout: timeout, handler: { error in
            XCTAssertNil(error)
            XCTAssertNotNil(self.error)
            XCTAssertEqual(self.error?.code, RideRequestViewErrorType.Unknown.rawValue)
            XCTAssertEqual(self.error?.domain, RideRequestViewErrorFactory.errorDomain)
        })
    }
    
    /**
     Test that no exception is thrown for authorization if custom access token is passed.
     */
    func testAuthorizeWithCustomAccessToken() {
        let tokenString = "accessToken1234"
        let tokenData = ["access_token" : tokenString]
        let token = AccessToken(JSON: tokenData)
        let view = RideRequestView(rideParameters: RideParametersBuilder().build(), accessToken: token, frame: CGRect.zero)
        XCTAssertNotNil(view.accessToken)
        XCTAssertEqual(view.accessToken, token)
    }
    
    /**
     Test that authorization passes with token in token manager.
     */
    func testAuthorizeWithTokenManagerAccessToken() {
        let tokenString = "accessToken1234"
        let tokenData = ["access_token" : tokenString]
        guard let token = AccessToken(JSON: tokenData) else {
            XCTAssert(false)
            return
        }
        TokenManager.saveToken(token)
        
        let view = RideRequestView()
        XCTAssertNotNil(view.accessToken)
        XCTAssertEqual(view.accessToken?.tokenString, TokenManager.fetchToken()?.tokenString)
        
        TokenManager.deleteToken()
    }
    
    /**
     Test that load is successful when access token is set after initialization.
     */
    func testAuthorizeWithTokenSetAfterInitialization() {
        let tokenString = "accessToken1234"
        let tokenData = ["access_token" : tokenString]
        let token = AccessToken(JSON: tokenData)
        let view = RideRequestView()
        view.accessToken = token
        XCTAssertNotNil(view.accessToken)
    }
    
    /**
     Test that exception is thrown without passing in custom access token (and none in TokenManager).
     */
    func testAuthorizeFailsWithoutAccessToken() {
        expectation = self.expectation(withDescription: "access token missing delegate call")
        let view = RideRequestView()
        view.delegate = self
        TokenManager.deleteToken()
        
        view.load()
        
        waitForExpectations(withTimeout: timeout, handler: { error in
            XCTAssertEqual(self.error?.code, RideRequestViewErrorType.AccessTokenMissing.rawValue)
            XCTAssertEqual(self.error?.domain, RideRequestViewErrorFactory.errorDomain)
            XCTAssertNil(error)
        })
    }
    
    func testRequestUsesCorrectSource_whenPresented() {
        let expectation = self.expectation(withDescription: "Test RideRequestView source call")
        
        let expectationClosure: (URLRequest) -> () = { request in
            expectation.fulfill()
            guard let url = request.url, let components = URLComponents(url: url, resolvingAgainstBaseURL: false), let items = components.queryItems else {
                XCTAssert(false)
                return
            }
            XCTAssertTrue(items.count > 0)
            var foundUserAgent = false
            for item in items {
                if (item.name == "user-agent") {
                    if let value = item.value {
                        foundUserAgent = true
                        XCTAssertTrue(value.containsString(RideRequestView.sourceString))
                        break
                    }
                }
            }
            XCTAssert(foundUserAgent)
        }
        
        let testIdentifier = "testAccessTokenIdentifier"
        TokenManager.deleteToken(testIdentifier)
        let testToken = AccessToken(JSON: ["access_token" : "testTokenString"])
        TokenManager.saveToken(testToken!, tokenIdentifier: testIdentifier)
        defer {
            TokenManager.deleteToken(testIdentifier)
        }
        
        let rideRequestView = RideRequestView(rideParameters: RideParametersBuilder().build(), accessToken: TokenManager.fetchToken(testIdentifier), frame: CGRect.zero)
        XCTAssertNotNil(rideRequestView)
        
        let webViewMock = WebViewMock(frame: CGRect.zero, configuration: WKWebViewConfiguration(), testClosure: expectationClosure)
        rideRequestView.webView.scrollView.delegate = nil
        rideRequestView.webView = webViewMock

        rideRequestView.load()
        
        
        waitForExpectations(withTimeout: timeout, handler: { error in
            XCTAssertNil(error)
        })
    }
    
    func testNotSupportedDelegateCalled_whenTel() {
        expectation = self.expectation(withDescription: "Delegate called")
        let cancelRequestExpectation = self.expectation(withDescription: "Request was cancelled")
        
        let rideRequestView = RideRequestView(rideParameters: RideParametersBuilder().build(), accessToken:nil, frame:CGRect.zero)
        rideRequestView.delegate = self
        let telURLString = "tel:5555555555"
        guard let telURL = URL(string: telURLString) else {
            XCTAssert(false)
            return
        }
        let telURLRequest = URLRequest(url: telURL)
        let navigationActionMock = WKNavigationActionMock(urlRequest: telURLRequest)
        
        if let delegate = rideRequestView.webView.navigationDelegate {
            delegate.webView!(rideRequestView.webView, decidePolicyForNavigationAction: navigationActionMock, decisionHandler: { (policy: WKNavigationActionPolicy) -> Void in
                XCTAssertEqual(policy, WKNavigationActionPolicy.Cancel)
                cancelRequestExpectation.fulfill()
            })
            
            waitForExpectations(withTimeout: timeout, handler: { error in
                XCTAssertNotNil(self.error)
                XCTAssertEqual(self.error?.code, RideRequestViewErrorType.NotSupported.rawValue)
            })
        } else {
            XCTAssert(false)
        }
    }
}

private class WKNavigationActionMock : WKNavigationAction {
    override var request: URLRequest {
        return backingRequest
    }
    var backingRequest = URLRequest()
    init(urlRequest: URLRequest) {
        backingRequest = urlRequest
        super.init()
    }
}

extension RideRequestViewTests: RideRequestViewDelegate {
    func rideRequestView(_ rideRequestView: RideRequestView, didReceiveError error: NSError) {
        self.error = error
        expectation.fulfill()
    }
}
