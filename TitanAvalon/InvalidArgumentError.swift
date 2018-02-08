//
//  InvalidArgumentError.swift
//  TitanAvalon
//
//  Created by paulps on 2018/2/3.
//  Copyright © 2018年 paulps. All rights reserved.
//

import Foundation

enum InvalidArgumentError: String, Error {
    case SetupStatusWrong = "Try to set illegle status in setup round."
}
