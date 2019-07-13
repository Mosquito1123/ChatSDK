//
//  VCard.swift
//  ios
//
//  Copyright © 2018 Tinode. All rights reserved.
//

import Foundation

public class Photo: Codable {
    public let type: String?
    // base64-encoded byte array.
    public let data: String?
    // Cached decoded image (not serialized).
    private var cachedImage: UIImage?

    private enum CodingKeys: String, CodingKey {
        case type
        case data
    }

    public init(type: String?, data: String?) {
        self.type = type
        self.data = data
    }

    convenience public init(type: String?, data: Data?) {
        self.init(type: type, data: data?.base64EncodedString())
    }

    convenience public init(image: UIImage) {
        
        self.init(type: "image/png", data: image.pngData())
    }

    public func image() -> UIImage? {
        if cachedImage == nil {
            guard let b64data = self.data else { return nil }
            guard let dataDecoded = Data(base64Encoded: b64data, options: .ignoreUnknownCharacters) else { return nil }
            cachedImage = UIImage(data: dataDecoded)
        }
        return cachedImage
    }
}

public class Contact: Codable {
    let type: String?
    let uri: String?
}

public class Name: Codable {
    let surname: String?
    let given: String?
    let additional: String?
    let prefix: String?
    let suffix: String?
}

public class VCard: Codable {
    public var fn: String?
    public var n: Name?
    public var org: String?
    public var title: String?
    // List of phone numbers associated with the contact.
    public var tel: [Contact]?
    // List of contact's email addresses.
    public var email: [Contact]?
    public var impp: [Contact]?
    // Avatar photo.
    public var photo: Photo?
    
    public init(fn: String?, avatar: Photo?) {
        self.fn = fn
        self.photo = avatar
    }

    public init(fn: String?, avatar: Data?) {
        self.fn = fn
        guard let avatar = avatar else { return }
        self.photo = Photo(type: nil, data: avatar)
    }

    public init(fn: String?, avatar: UIImage?) {
        self.fn = fn

        guard let avatar = avatar else { return }
        self.photo = Photo(image: avatar)
    }
}
