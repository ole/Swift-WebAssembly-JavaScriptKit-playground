#if arch(wasm32)
@_extern(wasm, module: "console", name: "log")
@_extern(c)
func consoleLog(address: Int, byteCount: Int)
#endif

func print(_ string: StaticString) {
    #if arch(wasm32)
        consoleLog(
            address: Int(bitPattern: string.utf8Start),
            byteCount: string.utf8CodeUnitCount
        )
    #else
        Swift.print(string)
    #endif
}

@_expose(wasm, "hello")
func hello() {
    print("Hello, World!")
}
