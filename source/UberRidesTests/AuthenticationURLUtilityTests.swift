//
//  AuthenticationURLUtilityTests.swift
//  UberRides
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

@testable import UberRides

class AuthenticationURLUtilityTests: XCTestCase {
    
    fileprivate var versionNumber: String?
    
    override func setUp() {
        super.setUp()
        Configuration.restoreDefaults()
        Configuration.plistName = "testInfo"
        Configuration.bundle = Bundle(forClass: self.dynamicType)
        versionNumber = Bundle(forClass: RideParameters.self).objectForInfoDictionaryKey("CFBundleShortVersionString") as? String
    }
    
    override func tearDown() {
        Configuration.restoreDefaults()
        super.tearDown()
    }
    
    func testBuildQueryParameters_withDefaultRegion_withSingleScope() {
        
        let scopes = [RidesScope.RideWidgets]
        
        let expectedScopes = scopes.toRidesScopeString()
        let expectedClientID = "testClientID"
        let expectedAppName = "My Awesome App"
        let expectedCallbackURI = "testURI://uberConnectNative"
        let expectedLoginType = "default"
        let expectedSDK = "ios"
        let expectedSDKVersion = versionNumber
        
        let scopeQueryItem = URLQueryItem(name: AuthenticationURLUtility.scopesKey, value: expectedScopes)
        let clientIDQueryItem = URLQueryItem(name: AuthenticationURLUtility.clientIDKey, value: expectedClientID)
        let appNameQueryItem = URLQueryItem(name: AuthenticationURLUtility.appNameKey, value: expectedAppName)
        let callbackURIQueryItem = URLQueryItem(name: AuthenticationURLUtility.callbackURIKey, value: expectedCallbackURI)
        let loginTypeQueryItem = URLQueryItem(name: AuthenticationURLUtility.loginTypeKey, value: expectedLoginType)
        let sdkQueryItem = URLQueryItem(name: AuthenticationURLUtility.sdkKey, value: expectedSDK)
        let sdkVersionQueryItem = URLQueryItem(name: AuthenticationURLUtility.sdkVersionKey, value: expectedSDKVersion)
        
        let expectedQueryItems = [scopeQueryItem, clientIDQueryItem, appNameQueryItem, callbackURIQueryItem, loginTypeQueryItem, sdkQueryItem, sdkVersionQueryItem]
        let comparisonSet = NSSet(array: expectedQueryItems)
        
        let testQueryItems = AuthenticationURLUtility.buildQueryParameters(scopes)
        let testComparisonSet = NSSet(array:testQueryItems)
        
        XCTAssertEqual(comparisonSet, testComparisonSet)
    }
    
    func testBuildQueryParameters_withDefaultRegion_withMultipleScopes() {
        
        let scopes = [RidesScope.RideWidgets, RidesScope.AllTrips, RidesScope.History]
        
        let expectedScopes = scopes.toRidesScopeString()
        let expectedClientID = "testClientID"
        let expectedAppName = "My Awesome App"
        let expectedCallbackURI = "testURI://uberConnectNative"
        let expectedLoginType = "default"
        let expectedSDK = "ios"
        let expectedSDKVersion = versionNumber
        
        let scopeQueryItem = URLQueryItem(name: AuthenticationURLUtility.scopesKey, value: expectedScopes)
        let clientIDQueryItem = URLQueryItem(name: AuthenticationURLUtility.clientIDKey, value: expectedClientID)
        let appNameQueryItem = URLQueryItem(name: AuthenticationURLUtility.appNameKey, value: expectedAppName)
        let callbackURIQueryItem = URLQueryItem(name: AuthenticationURLUtility.callbackURIKey, value: expectedCallbackURI)
        let loginTypeQueryItem = URLQueryItem(name: AuthenticationURLUtility.loginTypeKey, value: expectedLoginType)
        let sdkQueryItem = URLQueryItem(name: AuthenticationURLUtility.sdkKey, value: expectedSDK)
        let sdkVersionQueryItem = URLQueryItem(name: AuthenticationURLUtility.sdkVersionKey, value: expectedSDKVersion)
        
        let expectedQueryItems = [scopeQueryItem, clientIDQueryItem, appNameQueryItem, callbackURIQueryItem, loginTypeQueryItem, sdkQueryItem, sdkVersionQueryItem]
        let comparisonSet = NSSet(array: expectedQueryItems)
        
        let testQueryItems = AuthenticationURLUtility.buildQueryParameters(scopes)
        let testComparisonSet = NSSet(array:testQueryItems)
        
        XCTAssertEqual(comparisonSet, testComparisonSet)
    }
    
    func testBuildQueryParameters_withChinaRegion_withSingleScope() {
        
        Configuration.setRegion(.China)
        
        let scopes = [RidesScope.RideWidgets]
        
        let expectedScopes = scopes.toRidesScopeString()
        let expectedClientID = "testClientID"
        let expectedAppName = "My Awesome App"
        let expectedCallbackURI = "testURI://uberConnectNative"
        let expectedLoginType = "china"
        let expectedSDK = "ios"
        let expectedSDKVersion = versionNumber
        
        let scopeQueryItem = URLQueryItem(name: AuthenticationURLUtility.scopesKey, value: expectedScopes)
        let clientIDQueryItem = URLQueryItem(name: AuthenticationURLUtility.clientIDKey, value: expectedClientID)
        let appNameQueryItem = URLQueryItem(name: AuthenticationURLUtility.appNameKey, value: expectedAppName)
        let callbackURIQueryItem = URLQueryItem(name: AuthenticationURLUtility.callbackURIKey, value: expectedCallbackURI)
        let loginTypeQueryItem = URLQueryItem(name: AuthenticationURLUtility.loginTypeKey, value: expectedLoginType)
        let sdkQueryItem = URLQueryItem(name: AuthenticationURLUtility.sdkKey, value: expectedSDK)
        let sdkVersionQueryItem = URLQueryItem(name: AuthenticationURLUtility.sdkVersionKey, value: expectedSDKVersion)
        
        let expectedQueryItems = [scopeQueryItem, clientIDQueryItem, appNameQueryItem, callbackURIQueryItem, loginTypeQueryItem, sdkQueryItem, sdkVersionQueryItem]
        let comparisonSet = NSSet(array: expectedQueryItems)
        
        let testQueryItems = AuthenticationURLUtility.buildQueryParameters(scopes)
        let testComparisonSet = NSSet(array:testQueryItems)
        
        XCTAssertEqual(comparisonSet, testComparisonSet)
    }
    
    func testBuildQueryParameters_withChinaRegion_withMultipleScopes() {
        
        Configuration.setRegion(.China)
        
        let scopes = [RidesScope.RideWidgets, RidesScope.AllTrips, RidesScope.History]
        
        let expectedScopes = scopes.toRidesScopeString()
        let expectedClientID = "testClientID"
        let expectedAppName = "My Awesome App"
        let expectedCallbackURI = "testURI://uberConnectNative"
        let expectedLoginType = "china"
        let expectedSDK = "ios"
        let expectedSDKVersion = versionNumber
        
        let scopeQueryItem = URLQueryItem(name: AuthenticationURLUtility.scopesKey, value: expectedScopes)
        let clientIDQueryItem = URLQueryItem(name: AuthenticationURLUtility.clientIDKey, value: expectedClientID)
        let appNameQueryItem = URLQueryItem(name: AuthenticationURLUtility.appNameKey, value: expectedAppName)
        let callbackURIQueryItem = URLQueryItem(name: AuthenticationURLUtility.callbackURIKey, value: expectedCallbackURI)
        let loginTypeQueryItem = URLQueryItem(name: AuthenticationURLUtility.loginTypeKey, value: expectedLoginType)
        let sdkQueryItem = URLQueryItem(name: AuthenticationURLUtility.sdkKey, value: expectedSDK)
        let sdkVersionQueryItem = URLQueryItem(name: AuthenticationURLUtility.sdkVersionKey, value: expectedSDKVersion)
        
        let expectedQueryItems = [scopeQueryItem, clientIDQueryItem, appNameQueryItem, callbackURIQueryItem, loginTypeQueryItem, sdkQueryItem, sdkVersionQueryItem]
        let comparisonSet = NSSet(array: expectedQueryItems)
        
        let testQueryItems = AuthenticationURLUtility.buildQueryParameters(scopes)
        let testComparisonSet = NSSet(array:testQueryItems)
        
        XCTAssertEqual(comparisonSet, testComparisonSet)
    }
    
    func testShouldHandleRedirectURL() {
        let testRedirectURLString = "test://handleThis"
        guard let testRedirectURL = URL(string: testRedirectURLString) else {
            XCTFail()
            return
        }
        Configuration.setCallbackURIString(testRedirectURLString, type: .Implicit)
        XCTAssertFalse(AuthenticationURLUtility.shouldHandleRedirectURL(testRedirectURL, type: .General))
        XCTAssertFalse(AuthenticationURLUtility.shouldHandleRedirectURL(testRedirectURL, type: .Native))
        XCTAssertFalse(AuthenticationURLUtility.shouldHandleRedirectURL(testRedirectURL, type: .AuthorizationCode))
        
        XCTAssertTrue(AuthenticationURLUtility.shouldHandleRedirectURL(testRedirectURL, type: .Implicit))
        
        Configuration.setCallbackURIString(nil, type: .Implicit)
        
        XCTAssertFalse(AuthenticationURLUtility.shouldHandleRedirectURL(testRedirectURL, type: .Implicit))
    }
}
