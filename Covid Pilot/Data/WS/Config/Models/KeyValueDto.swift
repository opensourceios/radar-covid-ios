//
// KeyValueDto.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct KeyValueDto: Codable {

    public var _id: String?
    public var _description: String?

    public init(_id: String?, _description: String?) {
        self._id = _id
        self._description = _description
    }

    public enum CodingKeys: String, CodingKey { 
        case _id = "id"
        case _description = "description"
    }

}

