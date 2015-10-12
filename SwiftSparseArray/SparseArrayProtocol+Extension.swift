//
//  SparseArrayProtocol+Extension.swift
//  SwiftSparseArray
//
//  Created by Evan Mckee on 10/10/15.
//  Copyright © 2015 McKeeMaKer. All rights reserved.
//

import Foundation


///The protocol and its extension define and provide default implementation of nearly all the functionality needed for the sparse arrays. Due to some swift issues it's not currently possible to unite the SparseArrayNilDefault with the non optional SparseArray, but this protocol and extension ensure they function quite similarly.
public protocol SparseArrayProtocol: CollectionType, MutableCollectionType, CustomStringConvertible, RangeReplaceableCollectionType {
    typealias Element
    ///Essentially we want to ensure the Index is an integer with all the power and convenience that comes with that
    typealias Index:RandomAccessIndexType,Hashable,IntegerLiteralConvertible
    var data:[Index:Element] {get set}
    var defaultValue:Element {get}
    var startIndex:Index {get}
    var endIndex:Index {set get}
    var array:[Element] {get}
    var nonDefaultCount:Int {get}
    var nonDefaultIndices:[Index] {get}
    
    func elementIsdefaultValue(element: Element) -> Bool
    
}
public extension SparseArrayProtocol  {
    
    public var startIndex:Index {
        return 0
    }
    ///Number of non-nil values represented by the array
    public var nonDefaultCount:Int {
        return data.count
    }
    public var nonDefaultIndices:[Index]{
        return data.keys.sort()
    }
    
    public var array:[Element] {
        return self.map({$0 as! Self.Element})
    }
    
    public var description:String {
        return "\(self.array)"
    }
    
    
    ///Collection/MutableCollection conformance
    
    public subscript(position:Index)->Element{
        get{return data[position] ?? defaultValue}
        set{
            if elementIsdefaultValue(newValue) {
                if let dictIndex = data.indexForKey(position) {
                    data.removeAtIndex(dictIndex)
                }
            } else {
                data[position] = newValue
            }
        }
        
    }
    
    ////////////// RangeReplaceableCollectionType conformance//////////////
    mutating public func append(newElement: Element){
        self[endIndex++] = newElement
    }
    mutating public func appendContentsOf<S : SequenceType where S.Generator.Element == Generator.Element>(newElements: S) {
        for val in newElements {
            self.append(val as! Element)
        }
    }
    mutating public func insert(newElement: Self.Generator.Element, atIndex i: Self.Index) {
        //We need to modify the indices of equal or higher index elements from the top down
        
        let higherIndices = data.keys.filter({$0 >= i}).sort().reverse()
        endIndex++
        for j in higherIndices {
            self[j.successor()] = self[j]
            self[j] = defaultValue
        }
        self[i] = newElement
    }
    mutating public func insertContentsOf<S : CollectionType where S.Generator.Element == Generator.Element>(newElements: S, at i: Self.Index) {
        guard i <= endIndex else {fatalError("Array index out of range")}
        //The below cast should always work since both types are ultimately typedefed as Ints somewhere
        if let newElementCount = newElements.count as? Self.Index.Distance {
            guard newElementCount > 0 else {return}
            endIndex = endIndex.advancedBy(newElementCount)
            let higherIndices = data.keys.filter({$0 >= i}).sort().reverse()
            
            for j in higherIndices {
                self[j.advancedBy(newElementCount)] = self[j]
                self[j] = defaultValue
            }
            for (k,newItem) in newElements.enumerate() {
                self[i.advancedBy(k as! Self.Index.Distance)] = newItem
            }
            
            
        } else {
            print("failed to cast: newElementCount = newElements.count as? Self.Index.Distance")
            var insertIndex = i
            for item in newElements {
                self.insert(item, atIndex: insertIndex++)
            }
        }
        
    }
    mutating public func removeAll(keepCapacity keepCapacity: Bool) {
        endIndex = 0
        data.removeAll(keepCapacity: keepCapacity)
    }
    mutating public func removeAtIndex(index: Self.Index) -> Self.Generator.Element{
        let higherIndices = data.keys.filter({$0 > index}).sort()
        print(higherIndices)
        let returnValue = self[index]
        self[index] = defaultValue
        for j in higherIndices {
            self[j.predecessor()] = self[j]
            self[j] = defaultValue
        }
        endIndex--
        return returnValue
    }
    
    mutating public func removeFirst() -> Self.Generator.Element {
        return removeAtIndex(startIndex)
    }
    mutating public func removeFirst(n: Int) {
        let stopIndex:Self.Index = n as! Self.Index
        self.removeRange(startIndex..<stopIndex)
    }
    mutating public func removeRange(subRange: Range<Self.Index>) {
        guard subRange.count > 0 else {return}
        //first remove all elements in the range
        let inRangeIndices:[Self.Index] = data.keys.filter({($0 >= subRange.startIndex) && ($0 < subRange.endIndex)}).sort()
        //the higherIndices are all the values above but outside of the range which will need reindexing
        let higherIndices:[Self.Index] = data.keys.filter({$0 >= subRange.endIndex}).sort()
        for k in inRangeIndices {
            self[k] = defaultValue
        }
        for j in higherIndices {
            self[j.advancedBy(-subRange.count)] = self[j]
            self[j] = defaultValue
        }
        endIndex = endIndex.advancedBy(-subRange.count)
    }
    mutating public func replaceRange<C : CollectionType where C.Generator.Element == Generator.Element>(subRange: Range<Self.Index>, with newElements: C) {
        //simple implementation. This could be optimised as some of the other bulk operations have been.
        removeRange(subRange)
        insertContentsOf(newElements, at: subRange.startIndex)
    }
    
    
}