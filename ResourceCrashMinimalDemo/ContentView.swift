//
//  ContentView.swift
//  ResourceCrashMinimalDemo
//
//  Created by Konrad Feiler on 01.08.22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Button(action: { crash() }, label: { Text("Create Resouce") })
    }

    /// crashes in `outlined init with copy of Resource<VoidPayload, String>`
    func crash() {
        let testURL = URL(string: "https://www.google.com")!
        let r = Resource<VoidPayload, String>(url: testURL, method: .get, authToken: nil)
        print("r: \(r)")
    }
}

struct VoidPayload {}

enum HTTPMethod<Payload> {
    case get
    case post(Payload)
    case patch(Payload)
}

struct Resource<Payload, Response> {
    let url: URL
    let method: HTTPMethod<Payload>
    let query: [(String, String)]
    let authToken: String?
    let parse: (Data) throws -> Response
}

extension Resource where Response: Decodable {
    init(
        url: URL,
        method: HTTPMethod<Payload>,
        query: [(String, String)] = [],
        authToken: String?,
        headers: [String: String] = [:]
    ) {
        self.url = url
        self.method = method
        self.query = query
        self.authToken = authToken
        self.parse = {
            return try JSONDecoder().decode(Response.self, from: $0)
        }
    }
}

