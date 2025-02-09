// Copied (with slight modifications) from Simon Leeb
// Source: https://github.com/sliemeobn/elementary-dom/blob/85e6aa4f35cfd4920edb767014fc58bed25e7fd6/Examples/Swiftle/Sources/EmbeddedApp/_thingsThatShouldNotBeNeeded.swift
// More info: https://forums.swift.org/t/web-app-with-embedded-swift-poc-demo/75486

import JavaScriptKit

// NOTE: it seems the embedded tree shaker gets rid of these exports if they are not used somewhere
#if hasFeature(Embedded)
func _i_need_to_be_here_for_wasm_exports_to_work() {
    _ = _swjs_library_features
    _ = _swjs_call_host_function
    _ = _swjs_free_host_function
}
#endif

// TODO: move this to C
@_cdecl("strlen")
func strlen(_ s: UnsafePointer<Int8>) -> Int {
    var p = s
    while p.pointee != 0 {
        p += 1
    }
    return p - s
}

enum LCG {
    static var x: UInt8 = 0
    static let a: UInt8 = 0x05
    static let c: UInt8 = 0x0B

    static func next() -> UInt8 {
        x = a &* x &+ c
        return x
    }
}

// TODO: move this to C
@_cdecl("arc4random_buf")
public func arc4random_buf(_ buffer: UnsafeMutableRawPointer, _ size: Int) {
    for i in 0 ..< size {
        buffer.storeBytes(of: LCG.next(), toByteOffset: i, as: UInt8.self)
    }
}

/// NOTE: we would need a putchar for native print to work
func log(_ message: String) {
    _ = JSObject.global.console.log(message)
}
