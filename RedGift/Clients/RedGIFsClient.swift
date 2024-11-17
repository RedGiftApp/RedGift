//
//  RedGIFsClient.swift
//  RedGift
//
//  Created by eliottwang on 2024/11/15.
//

import Foundation

import ComposableArchitecture

struct RedGIFsClient {
    static let kHost = "https://api.redgifs.com"
    private static func buildUrl(_ components: String...) -> URL {
        var url = URL(string: kHost)!
        for component in components {
            url.appendPathComponent(component)
        }
        return url
    }

    static let kV2AuthTemporary = buildUrl("v2", "auth", "temporary")
    static let kV2FeedsHome = buildUrl("v2", "feeds", "home")

    static let kMaxRetries = 3
    static let kTokenKey = "redGIFsAuthToken"

    private func getAuthToken() async throws -> String {
        if let storedToken = UserDefaults.standard.string(forKey: Self.kTokenKey) {
            return storedToken
        } else {
            let authData = try await self.auth()
            UserDefaults.standard.set(authData.token, forKey: Self.kTokenKey)
            return authData.token
        }
    }

    var auth: () async throws -> Auth
    var feeds: () async throws -> GifList
}

extension RedGIFsClient: DependencyKey {
    static let liveValue: RedGIFsClient = .init(
        auth: {
            var request = URLRequest(url: Self.kV2AuthTemporary)
            request.httpMethod = "GET"
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            let decoder = JSONDecoder()
            return try decoder.decode(Auth.self, from: data)
        },
        feeds: {
            var attempts = 0
            while attempts < Self.kMaxRetries {
                do {
                    let token = try await liveValue.getAuthToken()
                    var request = URLRequest(url: Self.kV2FeedsHome)
                    request.httpMethod = "GET"
                    request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    let (data, response) = try await URLSession.shared.data(for: request)
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                    let decoder = JSONDecoder()
                    return try decoder.decode(GifList.self, from: data)
                } catch URLError.badServerResponse where attempts < Self.kMaxRetries - 1 {
                    attempts += 1
                    UserDefaults.standard.removeObject(forKey: Self.kTokenKey)
                }
            }
            throw URLError(.badServerResponse)
        }
    )
}

extension DependencyValues {
    var redGIFsClient: RedGIFsClient {
        get { self[RedGIFsClient.self] }
        set { self[RedGIFsClient.self] = newValue }
    }
}
