//
//  MarvelService.swift
//  marvel-ios-test
//
//  Created by Zachary Esmaelzada on 3/18/20.
//  Copyright © 2020 Zachary Esmaelzada. All rights reserved.
//

import Foundation

class MarvelService {
    static let service = MarvelService()
    
    func getComicInfo(id: Int, completion: @escaping (_ comic: ComicDetail?) -> Void) {
        let url = "https://gateway.marvel.com:443/v1/public/comics/\(id)?\(getCredentials())"
        guard let request = URL(string:url) else { return }
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil { //handle client error
                completion(nil)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else { //handle server error
                completion(nil)
                return
            }
            
            guard let data = data,
                let json = try? JSONSerialization.jsonObject(with: data, options: []),
                let jsonData = json as? [String: Any],
                let resultData = jsonData["data"] as? [String: Any],
                let comicDatas = resultData["results"] as? [[String: Any]],
                let comicData = comicDatas.first else {
                completion(nil)
                return
            }
            
            let comicDetail = ComicDetail(comicDict: comicData)
            completion(comicDetail)
            
        }
        task.resume()
    }
    
    private func getCredentials() -> String {
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5("\(ts)\(MarvelAPIKey.privateKey)\(MarvelAPIKey.publicKey)").lowercased()
        return "apikey=\(MarvelAPIKey.publicKey)&hash=\(hash)&ts=\(ts)"
    }
    
}
