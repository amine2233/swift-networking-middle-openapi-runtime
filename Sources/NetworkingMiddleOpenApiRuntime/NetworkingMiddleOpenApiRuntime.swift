import Foundation
import HTTPTypes
import NetworkingMiddle
import OpenAPIRuntime
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension NetworkProviderFactory {
    /// The client transporter
    /// - Parameter networkProvider: The networkProvider
    /// - Returns: ClientTransport
    public static func clientTransport(
        networkProvider: any NetworkProvider
    ) -> any ClientTransport {
        NetworkProviderClientTransport(
            networkProvider: networkProvider
        )
    }
}

struct NetworkProviderClientTransport: ClientTransport {
    private let networkProvider: any NetworkProvider

    init(networkProvider: any NetworkProvider) {
        self.networkProvider = networkProvider
    }

    func send(
        _ request: HTTPTypes.HTTPRequest,
        body: OpenAPIRuntime.HTTPBody?,
        baseURL: URL,
        operationID: String
    ) async throws -> (HTTPTypes.HTTPResponse, OpenAPIRuntime.HTTPBody?) {
        let parameters = request.url?.query().map { RequestParametersFactory.stringRequestParameters($0) }
        let bodyParameters = body.map { RequestBodyAsync(body: $0) }
        let requestBuilder = networkProvider.newBuilder(
            path: request.path ?? "",
            method: HTTPMethod(rawValue: request.method.rawValue),
            parameters: parameters,
            body: bodyParameters,
            headers: request.headerFields.reduce(into: [:]) { partialResult, field in
                partialResult[field.name.rawName] = field.value
            }
        )
        let response = try await networkProvider.request(
            baseURL: baseURL.absoluteString,
            request: requestBuilder
        )
        return (
            HTTPTypes.HTTPResponse(status: HTTPResponse.Status(code: response.statusCode)),
            response.body.map { OpenAPIRuntime.HTTPBody($0) }
        )
    }
}

/// Create a body with `Encodable` object
private struct RequestBodyAsync: RequestBody {
    let body: OpenAPIRuntime.HTTPBody

    func apply(urlRequest: URLRequest) async throws -> URLRequest {
        var request = urlRequest

        do {
            request.httpBody = try await Data(collecting: body, upTo: .max)
        } catch {
            throw APIError.requestParameters(error)
        }

        return request
    }
}
