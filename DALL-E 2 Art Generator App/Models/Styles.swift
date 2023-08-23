//
//  Styles.swift
//  DALL-E 2 Art Generator App
//
//  Created by Alex Ulanch on 8/23/23.
//

import Foundation

enum ImageStyle: String, CaseIterable {
    case none
    case abstract
    case cartoon
    case comic
    case expressionism
    case impressionism
    case popArt = "pop art"
    case realism
    case renaissance
    case surrealism
    
    var description: String {
        self != .none ? "An image in the style of \(rawValue) " : ""
    }
    
}

enum ImageMedium: String, CaseIterable {
    case none
    case digital = "digital art"
    case oil = "oil painting"
    case pastel
    case photo
    case spray = "spray paint"
    case watercolor
    
    var description: String {
        self != .none ? "in the medium of \(rawValue) " : ""
    }
    
}

enum Artist: String, CaseIterable {
    case none
    case dali = "Salvador Dali"
    case davinci = "Leonardo da Vinci"
    case matisse = "Henri Matisse"
    case monet = "Claud Monet"
    case picasso = "Pablo Picasso"
    case pollock = "Jackson Pollock"
    case vangogh = "Vincent van Gogh"
    case warhol = "Andy Warhol"
    
    var description: String {
        self != .none ? "similar to the works of \(rawValue) " : ""
    }
    
}
