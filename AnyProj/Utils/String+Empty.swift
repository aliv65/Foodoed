//
//  String+Empty.swift
//  AnyProj
//
//  Created by Александр Иванин on 11.11.17.
//

import Foundation

extension String {
    var isTrimmedEmpty: Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty
    }
}
