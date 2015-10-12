//
//  OtherProtocolsAndExtensions.swift
//  SwiftSparseArray
//
//  Created by Evan Mckee on 10/10/15.
//  Copyright © 2015 McKeeMaKer. All rights reserved.
//

import Foundation


///This protocol is used to ensure that elements of a conforing type are in fact optionals since type can't be checked without this in the necessary context due to how swift treats non-classes. 
public protocol OptionalProtocol: NilLiteralConvertible{
    //func isNil()->Bool
    func unwrapped()->Any!
}

///This extension allows the nil-default sparse array to work out of the box.
extension Optional: OptionalProtocol{
//    func isNil() -> Bool {
//        return self.flatMap({$0}) == nil
//    }
    public func unwrapped() -> Any! {
        return self.flatMap({$0})
    }
}




///Conforming types have an empty public initializer and are equatable. Conformance can be trivially added to most types. Any types being used in SparseArrayEquatableDefault must adopt this.
public protocol DefaultEquatableProtocol:Equatable {
    init()
}


//example conformances to DefaultEquatableProtocol:

//extension String:DefaultEquatableProtocol {}
//extension Int:DefaultEquatableProtocol {}