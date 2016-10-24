//
//  StoryTellerWrapper.swift
//  StoryTeller
//
//  Created by Derek Clarkson on 17/10/16.
//  Copyright © 2016 Derek Clarkson. All rights reserved.
//

import Foundation

public func STLog(_ key:AnyObject, file:String = #file, method:String = #function, line:Int32 = #line, _ messageTemplate:String, _ args:CVarArg...) {
    withVaList(args) {
        STStoryTeller.instance().record(key, file: file, method: method, lineNumber:line, message: messageTemplate, args: $0)
    }
}

public func STStartScope(_ key:AnyObject, _ block:() -> Void) {
    let x = STStoryTeller.instance().startScope(key)
    block()
    let _ = x
//    STStoryTeller.instance().endScope(key)
}
