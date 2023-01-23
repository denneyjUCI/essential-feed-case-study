//
//  HTTPURLResponse+Status.swift
//  EssentialFeed
//
//  Created by Jonathan Denney on 1/23/23.
//

import Foundation

extension HTTPURLResponse {
    var isOK: Bool {
        return statusCode == 200
    }
}
