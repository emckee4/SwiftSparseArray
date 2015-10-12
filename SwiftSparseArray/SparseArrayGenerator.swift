//
//  SparseArrayGenerator.swift
//  SwiftSparseArray
//
//  Created by Evan Mckee on 10/10/15.
//  Copyright © 2015 McKeeMaKer. All rights reserved.
//

import Foundation



public struct SparseGenerator<Element>: GeneratorType {
    
    private var items:[Int:Element]
    private var nextIndex:Int
    private var arrayLength:Int
    private var defaultValue:Element
    
    init(items:[Int:Element],arrayLength:Int, defaultValue:Element){
        self.items = items
        nextIndex = 0
        self.arrayLength = arrayLength
        self.defaultValue = defaultValue
    }
    mutating public func next() -> Element? {
        if nextIndex < arrayLength {
            return items[nextIndex++] ?? defaultValue
        } else {
            return nil
        }
    }
}
