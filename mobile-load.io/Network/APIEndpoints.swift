//
//  APIEndpoints.swift
//  mobile-load.io
//
//  Created by Djordje Arandjelovic on 26.6.24..
//

import Foundation

struct APIEndpoints {
    static let baseURL = "https://dev.az.loadio.app/"
    static let getAllLoadsEndpoint = "\(baseURL)loads/GetAllLoads"
    static let getLoadDetailedEndpoint = "\(baseURL)loads/GetLoadDetailed?loadID="
}

//https://dev.az.loadio.app/filemanager/PostFile?component_type=3&item_file_id=FILEID&file_sub_category=1
