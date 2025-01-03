import JavaScriptKit

@_expose(wasm, "run")
func run() {
    do {
        try runThrowing()
    } catch {
        log("Swift error thrown: \(error)")
    }
}

func runThrowing() throws {
    log("Hello from Swift!")
    let document = JSObject.global.document

    var divElement = document.createElement("div")
    divElement.innerText = "Hello from Swift!"
    _ = document.body.appendChild(divElement)

    _ = JSObject.global.alert!("Swift is running in the browser!")
}
