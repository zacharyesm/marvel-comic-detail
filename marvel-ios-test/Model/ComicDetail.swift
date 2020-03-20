//
//  ComicDetail.swift
//  marvel-ios-test
//
//  Created by Zachary Esmaelzada on 3/18/20.
//  Copyright © 2020 Zachary Esmaelzada. All rights reserved.
//

import Foundation

class ComicDetail {
    
    var id: Int!
    var title: String!
    var description: String!
    var imageUrl: String?
    
    init?(comicDict: [String: Any]) {
        guard let id = comicDict["id"] as? Int,
            let title = comicDict["title"] as? String,
            let description = comicDict["description"] as? String else {
                return nil
        }
        
        self.id = id
        self.title = title
        self.description = description
        
        if let photoDatas = comicDict["images"] as? [[String: Any]],
            let photoData = photoDatas.first,
            let path = photoData["path"] as? String,
            let ext = photoData["extension"] as? String {
            imageUrl = "\(path).\(ext)"
        }
        
    }
    
}
