//
//  SwiftPerformanceComparisonTests.swift
//  SwiftPerformanceComparisonTests
//
//  Created by Benedikt Terhechte on 20/06/15.
//  Copyright © 2015 Benedikt Terhechte. All rights reserved.
//

import XCTest

/**  Measure the performance
difference of functional Array modification versus non-functional array modification. This is
a good guidance as using functional modification on arrays looks much better, however seems to
perform much worse. Consider:
Replacement: Functional: 1.153 sec, Mutating: 0.527 sec
Appending: Functional: 0.057 sec, Mutating: 0.004 sec
*/

class SwiftPerformanceComparisonTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    // MARK: Replace in array
    
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
    
    // MARK: Append to array
    
    func testArrayFuncAppend() {
        // Measure Appending
        self.measureBlock { () -> Void in
            var arx: [Int] = []
            for i in 0..<10000 {
                arx = arx + [i]
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
    
    // MARK: Map versues for looops
    
    func testArrayFuncMap() {
        let t = Array(0...1000)
        self.measureBlock { () -> Void in
            for _ in 0...100 {
                t.map { $0 * 2}
            }
        }
    }
    
    func testArrayNFuncMap() {
        let t = Array(0...1000)
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
        let t = Array(0...1000)
        self.measureBlock { () -> Void in
            for _ in 0...100 {
                var r: [Int] = []
                for c in t {
                    r.append({ return c * 2}())
                }
            }
        }
    }
    
    // MARK: Filter vs For loops
    
    func testArrayFuncFilter() {
       let t = Array(0...1000)
        self.measureBlock { () -> Void in
            for _ in 0...100 {
                t.filter({ (e: Int) -> Bool in
                    return e % 3 == 0
                })
            }
        }
    }
    
    func testArrayNFuncFilter() {
       let t = Array(0...1000)
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
    
    // MARK: Flatten Nested Arrays
    
    func testNestedArrayNFunc() {
        
        let nestedArray = [Array(0...100), Array(100...200), Array(200...300), Array(300...400), Array(400...500), Array(500...600)]
        self.measureBlock { () -> Void in
            for _ in 0...100 {
                var nested: [Int] = []
                for n in nestedArray {
                    for u in n {
                        nested.append(u)
                    }
                }
            }
        }
    }
    
    func testNestedArrayNFuncRecur() {
        
        func recurse(inout container: [Int], xs: [AnyObject]) {
            for n in xs {
                switch n {
                case let v as [Int]:
                    recurse(&container, xs: v)
                case let v as Int:
                    container.append(v)
                default: ()
                }
            }
        }
        
        let nestedArray = [Array(0...100), Array(100...200), Array(200...300), Array(300...400), Array(400...500), Array(500...600)]
        self.measureBlock { () -> Void in
            for _ in 0...100 {
                var nested: [Int] = []
                recurse(&nested, xs: nestedArray)
            }
        }
    }
    
    func testNestedArrayFuncJoin() {
        
        let nestedArray = [Array(0...100), Array(100...200), Array(200...300), Array(300...400), Array(400...500), Array(500...600)]
        self.measureBlock { () -> Void in
            for _ in 0...100 {
                let nested: [Int] = [].join(nestedArray)
            }
        }
    }
    
    func testNestedArrayFuncFlatMap() {
        
        let nestedArray = [Array(0...100), Array(100...200), Array(200...300), Array(300...400), Array(400...500), Array(500...600)]
        self.measureBlock { () -> Void in
            for _ in 0...100 {
                let nested = nestedArray.flatMap{$0}
            }
        }
    }
    
    func testNestedArrayFuncReduce() {
        
        let nestedArray = [Array(0...100), Array(100...200), Array(200...300), Array(300...400), Array(400...500), Array(500...600)]
        self.measureBlock { () -> Void in
            for _ in 0...100 {
                let nested = nestedArray.reduce([], combine: {$0 + $1})
            }
        }
    }
    
}
