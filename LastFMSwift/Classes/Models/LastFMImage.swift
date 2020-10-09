//
//  LastFMImage.swift
//  LastFMSwift
//
//  Created by Daniel Chirita on 09/10/2020.
//

import Foundation

open class LastFMImage: Decodable {
    
    public let url: String
    public let size: String
    
    enum CodingKeys: String, CodingKey {
        case url = "#text"
        case size
    }
}
