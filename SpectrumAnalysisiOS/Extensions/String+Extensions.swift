//
//  String+Extensions.swift
//  SpectrumAnalysisiOS
//
//  Created on [Date]
//

import Foundation

extension String {
    var toURL: URL? {
        URL(string: self)
    }
}
