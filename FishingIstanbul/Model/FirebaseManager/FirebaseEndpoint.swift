//
//  FirebaseEndpoint.swift
//  Balık Avı - İstanbul Balık Avı
//
//  Created by Emir AKSU on 6.08.2024.
//

import Foundation
import Firebase

protocol FirebaseEndpointProtocol {
    
    var query : Query { get }
}

enum FirebaseEndpoint {
    case addSnapshotListener(path : CollectionReference)
}

extension FirebaseEndpoint : FirebaseEndpointProtocol{
    var query: Query {
        switch self {
        case .addSnapshotListener(let path):
            return path
            
        }
        
        
    }
   
    
    
}
