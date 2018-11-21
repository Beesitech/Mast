//
//  Client.swift
//  MastodonKit
//
//  Created by Ornithologist Coder on 4/22/17.
//  Copyright © 2017 MastodonKit. All rights reserved.
//

import Foundation

public struct Client: ClientType {
    let baseURL: String
    let session: URLSession
//    enum Constant: String {
//        case sessionID = "com.shi.Mast.bgSession"
//    }
//    var session: URLSession = {
//        let config = URLSessionConfiguration.background(withIdentifier: Constant.sessionID.rawValue)
//        config.isDiscretionary = true
//        config.sessionSendsLaunchEvents = true
//        return URLSession(configuration: config, delegate: nil, delegateQueue: nil)
//    }()
    public var accessToken: String?

    public init(baseURL: String, accessToken: String? = nil, session: URLSession = .shared) {
        self.baseURL = baseURL
        self.session = session
        self.accessToken = accessToken
    }

    public func run<Model>(_ request: Request<Model>, completion: @escaping (Result<Model>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
        guard
            let components = URLComponents(baseURL: self.baseURL, request: request),
            let url = components.url
            else {
                completion(.failure(ClientError.malformedURL))
                return
        }

        let urlRequest = URLRequest(url: url, request: request, accessToken: self.accessToken)
        let task = self.session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(ClientError.malformedJSON))
                return
            }

            guard
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
                else {
                    let mastodonError = try? MastodonError.decode(data: data)
                    let error: ClientError = mastodonError.map { .mastodonError($0.description) } ?? .genericError
                    completion(.failure(error))
                    return
            }

            guard let model = try? Model.decode(data: data) else {
                completion(.failure(ClientError.invalidModel))
                return
            }

            completion(.success(model, httpResponse.pagination))
        }

        task.resume()
        }
    }
}
