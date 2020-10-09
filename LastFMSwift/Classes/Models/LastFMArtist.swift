//
//  LastFMArtist.swift
//  LastFMSwift
//
//  Created by Daniel Chirita on 09/10/2020.
//

import Foundation

open class LastFMArtist: Decodable {
    
    public let name: String
    public let url: String?
    public let images: [LastFMImage]?
    public let bio: LastFMBio?
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
        case images = "image"
        case bio
    }
}
