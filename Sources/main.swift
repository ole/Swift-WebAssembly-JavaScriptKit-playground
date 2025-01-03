import JavaScriptKit

@_expose(wasm, "run")
func run() {
    log("Hello from Swift!")
    let document = JSObject.global.document

    let containerDiv: JSValue = document.getElementById("container")
    var divElement: JSValue = document.createElement("div")
    divElement.innerText = "Hello from Swift!"
    _ = containerDiv.appendChild(divElement)

    let canvas = document.getElementById("canvas")
    var ctx: JSValue = canvas.getContext("2d")
    ctx.fillStyle = "#ff0000"
    _ = ctx.object!.fillRect.function!(this: ctx.object!, arguments: [20, 20, 200, 100])
}
