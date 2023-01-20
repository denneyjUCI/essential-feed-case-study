//
//  Image Comments.swift
//  EssentialFeed
//
//  Created by Jonathan Denney on 1/13/23.
//

import Foundation

public struct ImageComment: Hashable {
    public let id: UUID
    public let message: String
    public let createdAt: Date
    public let username: String

    public init(id: UUID, message: String, createdAt: Date, username: String) {
        self.id = id
        self.message = message
        self.createdAt = createdAt
        self.username = username
    }
}
