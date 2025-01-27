//
//  SelectionParamsHolder.swift
//  
//
//  Created by Alisa Mylnikova on 05.05.2023.
//

import SwiftUI

final class SelectionParamsHolder: ObservableObject {

    @Published var mediaType: MediaSelectionType = .photoAndVideo
    @Published var selectionStyle: MediaSelectionStyle = .checkmark
    @Published var selectionLimit: Int? // if nil - unlimited
}

public enum MediaSelectionStyle {
    case checkmark
    case count
}

public enum MediaSelectionType {
    case photoAndVideo
    case photo
    case video

    var allowsPhoto: Bool {
        [.photoAndVideo, .photo].contains(self)
    }

    var allowsVideo: Bool {
        [.photoAndVideo, .video].contains(self)
    }
}
