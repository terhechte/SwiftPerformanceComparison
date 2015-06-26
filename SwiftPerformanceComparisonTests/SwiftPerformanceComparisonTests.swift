//
//  SwiftPerformanceComparisonTests.swift
//  SwiftPerformanceComparisonTests
//
//  Created by Benedikt Terhechte on 20/06/15.
//  Copyright © 2015 Benedikt Terhechte. All rights reserved.
//

import XCTest

class SwiftPerformanceComparisonTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**  Measure the performance
    difference of functional Array modification versus non-functional array modification. This is
    a good guidance as using functional modification on arrays looks much better, however seems to
    perform much worse. Consider:
    Replacement: Functional: 1.153 sec, Mutating: 0.527 sec
    Appending: Functional: 0.057 sec, Mutating: 0.004 sec
    */
    func testArrayFuncReplace() {
        // Measure Replacement
        self.measureBlock() {
            var cx = 0
            for i in 0..<100000 {
                let ix = [i, i + 1, i + 2, i + 3, i + 4, i + 5]
                // we want to measure this
                let ix2 = [5 + i * 2] + Array(ix[1..<ix.count])
                
                let s = ix2.reduce(0, combine: (+))
                cx += s
            }
        }
        
    }
    
    func testArrayFuncAppend() {
        // Measure Appending
        self.measureBlock { () -> Void in
            var arx: [Int] = []
            for i in 0..<10000 {
                arx = arx + [i]
            }
        }
    }
    
    func testArrayNFuncReplace() {
        // Measure Replacement
        self.measureBlock() {
            var cx = 0
            for i in 0..<100000 {
                var ix = [i, i + 1, i + 2, i + 3, i + 4, i + 5]
                // We want to measure this
                ix.replaceRange(0..<1, with: [5 + i * 2])
                let s = ix.reduce(0, combine: (+))
                cx += s
            }
        }
        
    }
    
    func testArrayNFuncAppend() {
        // Measure Appending
        self.measureBlock { () -> Void in
            var arx:[Int] = []
            for i in 0..<10000 {
                arx.append(i)
            }
        }
    }
    
    func testArrayFuncMap() {
        let t = 0...1000
        self.measureBlock { () -> Void in
            for _ in 0...100 {
                t.map { $0 * 2}
            }
        }
    }
    
    func testArrayNFuncMap() {
        let t = 0...1000
        self.measureBlock { () -> Void in
            for _ in 0...100 {
                var r: [Int] = []
                for c in t {
                    r.append(c * 2)
                }
            }
        }
    }
    
    func testArrayHNFuncMap() {
        // half-test,
        let t = 0...1000
        self.measureBlock { () -> Void in
            for _ in 0...100 {
                var r: [Int] = []
                for c in t {
                    r.append({ return c * 2}())
                }
            }
        }
    }
    
    func testArrayFuncFilter() {
       let t = 0...1000
        self.measureBlock { () -> Void in
            for _ in 0...100 {
                t.filter({ (e: Int) -> Bool in
                    return e % 3 == 0
                })
            }
        }
    }
    
    func testArrayNFuncFilter() {
        let t = 0...1000
        self.measureBlock { () -> Void in
            for _ in 0...100 {
                var r: [Int] = []
                for c in t {
                    if c % 3 == 0 {
                        r.append(c)
                    }
                }
            }
        }
    }
}
