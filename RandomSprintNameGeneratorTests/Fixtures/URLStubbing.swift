//
//  URLStubbing.swift
//  RandomSprintNameGeneratorTests
//
//  Created by Yannick Brands on 14.02.23.
//

import Foundation
import XCTest
@testable import RandomSprintNameGenerator

/// Class to stub/mock outgoing requests.
///
/// This type serves as a means to intercept outgoing requests (that would normally go to the backend) and stub
/// mock custom responses during tests. By default it does that for HTTP requests once activated.
///  - Important: You **must** activate stubbing globally with the `register` method before you run any tests
///  against endpoints to guarantee no actual traffic is going out of the app. You also **must**             deactivate stubbing with `unregister` once you're done!
class URLStubbing: URLProtocol {
    
/// Stub error.
///
/// Set this to a closure to generate a fitting response and optional return data during tests. You can also use
/// this to verify that a request is handled by `URLStubbing` during tests. When `stubError` is non-nil, the
/// closure is ignored, i.e. errors have a higher priority than regular responses
    static var stubResponseAndData: ((URLRequest) -> (URLResponse, Data?))?
    
/// Stub error.
///
/// Set this to a closure to generate a fitting error during tests. You can also use this to verify that a request
///  is handled by `URLStubbing` during tests. If this is non-nil, the `stubResponseAndData` closure is
///  ignored (note that you cannot have an Error _and_ a `URLResponse` and `Data`).
    static var stubError: ((URLRequest) -> NSError?) = { _ in return nil }
    
/// The schemes to stub. Default is `["http"]`.
///
///The URLs prepared for testing should all just be plain HTTP URLs (as SSL certificate handling in UI tests is
///way too complicated for now), so in unit tests we use the same and stub for those. If needed, other
/// schemes can added here, but note that `resetStubs` and `unregister` change this back to the
/// default array again.
    static var stubSchemes = ["http"]
    
/// Shorthand to register the class as URL protocol
    class func register() {
        URLProtocol.registerClass(Self.self)
    }
    
/// Shorthand to unregister the class as URL protocol
    class func unregister() {
        Self.resetStubs()
        URLProtocol.unregisterClass(Self.self)
    }
    
/// Resets all static stub variables back to their default.
    class func resetStubs() {
        Self.stubResponseAndData = nil
        Self.stubError = { _ in return nil }
        Self.stubSchemes = ["http"]
    }
    
    // MARK: - Necessary class overrides
    override class func canInit(with request: URLRequest) -> Bool {
        guard let scheme = request.url?.scheme else { return false }
        return Self.stubSchemes.contains(scheme)
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    // note: the parameter names come from the standard frameworks directly, so we tell swiftlint to eff off... :D
    // swiftlint:disable:next identifier_name
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    // MARK: - Necessary instance overrides
    
    // The heart of intercepting outgoing requests matching the scheme.
    override func startLoading() {
        if let error = Self.stubError(self.request) {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        if let (response, data) = Self.stubResponseAndData?(self.request) {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {
    }
}

// MARK: - Some useful reusable errors, responses, etc.

extension URLStubbing {
    
    class func simple200Response(for request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    static let simpleAcceptWithoutData: (URLRequest) -> (URLResponse, Data?) = { request in
        return (URLStubbing.simple200Response(for: request), nil)
    }
    static let simple401Response: (URLRequest) -> (URLResponse, Data?) = { request in
        return (HTTPURLResponse(url: request.url!, statusCode: 401, httpVersion: nil, headerFields: nil)!, nil)
    }
    static let simpleNoInternetError: (URLRequest) -> (NSError) = { _ in
        return NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet, userInfo: nil)
    }
    static let simpleCustomError: (URLRequest) -> (NSError) = { _ in
        return NSError(domain: NSURLErrorDomain, code: 666, userInfo: nil)
    }
}

// MARK: - Getting a body from a requests bodyStream
extension URLStubbing {
    
    static func getBodyStreamData(from request: URLRequest) -> Data? {
        guard let bodyStream = request.httpBodyStream else { return nil }
        bodyStream.open()
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        defer {
            buffer.deallocate()
            bodyStream.close()
        }
        var retVal = Data()
        while bodyStream.hasBytesAvailable {
            let readBytes = bodyStream.read(buffer, maxLength: 16)
            retVal.append(buffer, count: readBytes)
        }
        return retVal
    }
}
// MARK: - Test URLRepository creation
//extension URLStubbing {
//
//    static func makeTestRepo(for testCase: XCTestCase, name: String, useTestBundle: Bool = true) -> URLRepository {
//        guard useTestBundle else {
//            return URLRepository(repoPlistName: name)
//        }
//        let testBundle = Bundle(for: type(of: testCase))
//        return URLRepository(repoPlistName: name, bundle: testBundle)
//    }
//}
