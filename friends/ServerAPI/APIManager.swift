//
//  APIManager.swift
//  friends
//
//  Created by Faysal on 28/3/23.
//

import UIKit

class APIManager {
    static let shared = APIManager() // shared instance
    private init() {} // Prevent creation (Thread safe)
    
    private var seed = "" // seed value for pagination (If seed changes, content changes)
    private var onRequest = false // bool value that indicates communication status

    
    func getUsersList(pageNo : UInt, itemCnt : UInt,
                      onSuccess : @escaping ((Array<User>)->Void), onFail : @escaping ((Error)->Void)) {
        self.onRequest = true
        
        // make request query string
        var queries = Dictionary<String, String>()
        
        // add default values
        queries[PARAM_PAGE] = String(pageNo)
        queries[PARAM_ITEM_PER_PAGE] = String(itemCnt)
        
        // add seed if exists
        if(!seed.isEmpty) {
            queries[PARAM_SEED] = seed
        }
      
        
        // make request object
        var request = URLRequest(url: makeRequestURL(url: BASE_URL, query: makeQuery(dict: queries)))
        request.httpMethod = "GET"
        
        
        // and make data task
        let task = URLSession.shared.dataTask(with: request) { (data, resp, err) in
            if(err != nil) {
                DispatchQueue.main.async {  // call delegate in main queue
                    self.onRequest = false
                    onFail(err!)
                }
            } else {
                    if let data = data {
                       do {
                         let recharge = try JSONDecoder().decode(Friends.self, from: data)
                           onSuccess(recharge.results)
                           
                       } catch let error {
                           DispatchQueue.main.async {  // call delegate in main queue
                               self.onRequest = false
                               onFail(error)
                           }
                       }
                    }
//                    let recharge = try JSONDecoder().decode(Friends.self, from: data)
//                    self.seed = (result["info"] as! JsonObj)["seed"] as? String ?? ""
//                    self.onRequest = false
//
//                    DispatchQueue.main.async { // call delegate in main queue
//                        onSuccess((result["results"] as! Array<JsonObj>).map {
//                            User(dict: $0)
//                        })
//                    }
            
            }
        }
        
        // start task if it's not started
        task.resume()
    }
    
    private func makeQuery(dict : Dictionary<String, String>) -> String {
        return dict.reduce("") {
            return $0 + "\($1.key)=\($1.value)&"
        }
    }
    
    private func makeRequestURL(url : String, query : String) -> URL {
        return URL(string: url + "?" + query)!
    }
    
    func resetSeed() { // Reset seed for new content
        seed = ""
    }
    
    func isOnRequest() -> Bool { // Check is processing a request
        return onRequest
    }

}
