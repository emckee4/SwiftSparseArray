//
//  SparseArrayImplementations.swift
//  SwiftSparseArray
//
//  Created by Evan Mckee on 10/10/15.
//  Copyright © 2015 McKeeMaKer. All rights reserved.
//

import Foundation


///This version of sparse array allows the use of optionals, though requiring the default/empty value to be nil.
public struct SparseArrayNilDefault<Element:OptionalProtocol>: SparseArrayProtocol, ArrayLiteralConvertible  {
    
    public typealias Index = Int

    public var data:[Index:Element] = [:]
    
    public let defaultValue:Element = nil
    
    public var endIndex:Index = 0
    
    public typealias Generator = SparseGenerator<Element>
    /////  Generator/SequenceType congormance
    public func generate() -> Generator {
        return Generator(items:data,arrayLength:endIndex, defaultValue:defaultValue)
    }
    
    public init(){
        
    }
    
    public init(length:Int){
        self.endIndex = length
    }
    
    ///Initializes a sparse array with the contents of the provided array.
    public init(array:[Element]){
        self.appendContentsOf(array)
    }
    
    public init(arrayLiteral elements: Element...) {
        self.insertContentsOf(elements, at: startIndex)
    }
    
    
    public func elementIsdefaultValue(element: Element) -> Bool {
        return (element as Optional) == nil//element.isNil()
    }
    
    
}



///General, non optional sparse array. The one caveat to using this version as opposed to SparseArrayNilDefault is that any type used must be made to conform to DefaultEquatableProtocol which only requires an empty init() which provides a default value that the type conforms to Equatable. A different default may be provided for specific instances of SparseArrayEquatableDefault using extended initializers
public struct SparseArrayEquatableDefault<Element:DefaultEquatableProtocol>: SparseArrayProtocol, ArrayLiteralConvertible {
    
    public typealias Index = Int
    
    public var data:[Index:Element] = [:]
    
    public var defaultValue:Element
    
    public var endIndex:Index = 0
    
    
    
    public typealias Generator = SparseGenerator<Element>
    /////  Generator/SequenceType congormance
    public func generate() -> Generator {
        return Generator(items:data,arrayLength:endIndex, defaultValue:defaultValue)
    }
    
    
    public func elementIsdefaultValue(element: Element) -> Bool {
        return element == defaultValue
    }
    
    
    public init(){
        defaultValue = Element()
    }
    
    public init(length:Int){
        defaultValue = Element()
        self.endIndex = length
    }
    
    ///Initializes a sparse array with the contents of the provided array.
    public init(array:[Element]){
        defaultValue = Element()
        self.appendContentsOf(array)
    }
    
    public init(length:Int, defaultValue:Element){
        self.endIndex = length
        self.defaultValue = defaultValue
    }
    
    ///Initializes a sparse array with the contents of the provided array.
    public init(array:[Element], defaultValue:Element){
        self.defaultValue = defaultValue
        self.appendContentsOf(array)
    }
    
    
    public init(arrayLiteral elements: Element...) {
        self.defaultValue = Element()
        self.insertContentsOf(elements, at: startIndex)
    }
    
    
    
}



