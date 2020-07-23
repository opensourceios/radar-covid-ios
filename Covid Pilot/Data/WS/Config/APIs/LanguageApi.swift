//
// TokenAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire
import RxSwift


open class LanguageApi {
    
//    private let clientApi : SwaggerClientAPI
//
//    init(clientApi : SwaggerClientAPI) {
//        self.clientApi = clientApi;
//    }
    
    
    
  
    
    open func getLanguageWithLocale(locale: String = "es-ES") -> DataRequest {
        // https://cdn.contentful.com/spaces/fkltdlmuiyh6/environments/master/entries?access_token=Dv96LuZTUWSVMI_nxl59g30RPqi7TTeYkEr-UC4L6Qs&select=fields&content_type=iosData&locale=es-ES
        let parameters = [
            "access_token": "Dv96LuZTUWSVMI_nxl59g30RPqi7TTeYkEr-UC4L6Qs",
            "select": "fields",
            "content_type": "iosData",
            "locale": locale
        ]

        return Alamofire.request("https://cdn.contentful.com/spaces/fkltdlmuiyh6/environments/master/entries", method: HTTPMethod.get, parameters: parameters, encoding: URLEncoding.default, headers: nil)
      
    }
    
    
}
