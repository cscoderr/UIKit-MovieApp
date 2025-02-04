//
//  String+Extension.swift
//  MovieApp
//
//  Created by Tomiwa Idowu on 2/2/25.
//

import Foundation

extension String {
    var toUrl: URL? {
        return URL(string: self)
    }
}
