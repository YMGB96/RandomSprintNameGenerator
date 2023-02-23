//
//  URLStubbing.swift
//  RandomSprintNameGeneratorTests
//
//  Created by Yannick Brands on 14.02.23.
//

import Foundation
import XCTest
@testable import RandomSprintNameGenerator

import Foundation

class URLStubbing: URLProtocol {

    static var stubResult: (URLRequest) -> StubResult? = { _ in return nil }

    static var stubScheme = "https"

    static func register() {
        URLProtocol.registerClass(Self.self)
    }

    static func unregister() {
        URLProtocol.unregisterClass(Self.self)
    }

    // MARK: - Necessary class overrides
    override static func canInit(with request: URLRequest) -> Bool {
        guard let scheme = request.url?.scheme else { return false }
        return Self.stubScheme.contains(scheme)
    }

    override static func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override static func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }

    // MARK: - Necessary instance overrides

    // The heart of intercepting outgoing requests matching the scheme.
    override func startLoading() {
        let intendedResult = Self.stubResult(request)
        var respAndData: (response: URLResponse, data: Data)?
        var foundError: Error?
        var respNoData: URLResponse?

        switch intendedResult {
        case .simple200ResponseWithData(let data):
            respAndData = (response: response(url: request.url!), data: data)
        case .simple401Response:
            respNoData = response(url: request.url!, code: 401)
        case .customResponseAndData(let response, let data):
            respAndData = (response: response, data: data)
        case .customError(let error):
            foundError = error
        case .simpleNoInternetError:
            foundError = NSError(domain: NSURLErrorDomain, code: NSURLErrorNotConnectedToInternet)
        default:
            break
        }

        if let respAndData = respAndData {
            client?.urlProtocol(self, didReceive: respAndData.response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: respAndData.data)
            client?.urlProtocolDidFinishLoading(self)
        } else if let respNoData = respNoData {
            client?.urlProtocol(self, didReceive: respNoData, cacheStoragePolicy: .notAllowed)
            client?.urlProtocolDidFinishLoading(self)
        } else if let mockError = foundError as? MockError {
            client?.urlProtocol(self, didFailWithError: mockError.asNSError)
        } else if let error = foundError as? NSError {
            client?.urlProtocol(self, didFailWithError: error)
        } else if let error = foundError {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
    }
}

// MARK: - The Stub-Result-Defining sub-type
extension URLStubbing {

    enum StubResult {
        case customResponseAndData(URLResponse, Data)
        case customError(Error)
        case simple200ResponseWithData(Data)
        case simpleNoInternetError
        case simple401Response
    }

    enum MockError: Error {
        case plainError
        case errorWithInfo(String)

        var asNSError: NSError {
            return NSError(domain: "URLStubbing.MockError", code: 666, userInfo: ["case" : "\(self)"])
        }
    }
}

// MARK: - Private helpers
private extension URLStubbing {

    func response(url: URL, code: Int = 200, headers: [String: String]? = nil) -> URLResponse {
        return HTTPURLResponse(url: url, statusCode: code, httpVersion: nil, headerFields: headers)!
    }
}
