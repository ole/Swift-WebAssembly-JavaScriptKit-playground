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
    // Draw a rectangle
    // With more than 2 arguments, we have to use this ugly call style.
    // Reason (I think): Embedded Swift limitations
    ctx.fillStyle = "#ff9900"
    _ = ctx.object!.fillRect.function!(this: ctx.object!, arguments: [20, 20, 200, 100])
    // Draw a triangle
    ctx.strokeStyle = "#ff00ff"
    ctx.lineWidth = 4
    _ = ctx.beginPath()
    _ = ctx.moveTo(80, 200)
    _ = ctx.lineTo(160, 60)
    _ = ctx.lineTo(240, 200)
    _ = ctx.closePath()
    _ = ctx.stroke()
}
