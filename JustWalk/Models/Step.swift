//
//  Step.swift
//  JustWalk
//
//  Created by M100-M1MacMini on 2022/3/3.
//

import Foundation

struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}
