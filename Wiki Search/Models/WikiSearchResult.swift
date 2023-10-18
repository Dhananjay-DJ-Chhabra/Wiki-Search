//
//  WikiSearchResult.swift
//  Wiki Search
//
//  Created by Dhananjay Chhabra on 18/10/23.
//

import Foundation


struct WikiSearchResult: Codable {
    let query: Query
    let limits: Limits
}

struct Limits: Codable {
    let pageimages, extracts: Int
}

struct Query: Codable {
    let pages: [String: Page]
}

struct Page: Codable {
    let pageid, ns: Int
    let title: String
    let index: Int
    let thumbnail: Thumbnail?
    let pageimage: String?
    let extract: String
}

struct Thumbnail: Codable {
    let source: String
    let width, height: Int
}

struct Continue: Codable {
    let gsroffset: Int
    let continueContinue: String
}
