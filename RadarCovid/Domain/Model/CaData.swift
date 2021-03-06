//

// Copyright (c) 2020 Gobierno de España
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.
//
// SPDX-License-Identifier: MPL-2.0
//

import Foundation

struct CaData: Codable {

    public var id: String?
    public var description: String?

    public var phone: String?
    public var email: String?
    public var web: String?
    public var webName: String?
    public var additionalInfo: String?

    public init(id: String?, description: String?, phone: String?, email: String?,
                web: String?, webName: String?, additionalInfo: String?) {
        self.id = id
        self.description = description
        self.phone = phone
        self.email = email
        self.additionalInfo = additionalInfo
        self.web = web
        self.webName = webName
    }
    
    static func emptyCaData() -> CaData {
        return CaData.init(id: "", description: "", phone: "", email: "", web: "", webName: "", additionalInfo: "")
    }

}
