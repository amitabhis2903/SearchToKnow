//
//  Service.swift
//  SearchToKnow
//
//  Created by A on 12/07/19.
//  Copyright © 2019 A. All rights reserved.
//

import Foundation
import SystemConfiguration

//@Catch service error
enum ServiceError: Error {
    case noInternetConnection
    case custom(String)
    case other
}


extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No Internet connection"
        case .other:
            return "Something went wrong"
        case .custom(let message):
            return message
        }
    }
}



class Service: NSObject {
    
    static let shared = Service()
    
    private override init() {
    }
    
    
    func getData<T: Decodable>(urlString: String, completion: @escaping (T?, ServiceError?) -> ()) {
        
        if !MIReachability.isConnectedToNetwork() {
            completion(nil, ServiceError.noInternetConnection)
            return
        }
        guard let url = URL(string: urlString) else {
            completion(nil, ServiceError.custom("Bad Url"))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Bad Url: \(error.localizedDescription)")
            }
            
            
            guard let data = data else {
                completion(nil, .custom("Bad data"))
                return
            }
            
            do {
                let objc = try JSONDecoder().decode(T.self, from: data)
                completion(objc, nil)
            }catch let error {
                print("Failed to decode data: \(error.localizedDescription)")
            }
            
        }.resume()
    }
}


final class MIReachability {
    
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
}
