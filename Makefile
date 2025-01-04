TOOLCHAIN_DIR := ${HOME}/Library/Developer/Toolchains/swift-latest.xctoolchain

# Build instructions adapted from Simon Leeb:
# https://forums.swift.org/t/web-app-with-embedded-swift-poc-demo/75486
wasmlib:
	echo "Using toolchain dir: ${TOOLCHAIN_DIR}"
	# Activate Swift development toolchain and build the Wasm module.
	export TOOLCHAINS=$$(plutil -extract CFBundleIdentifier raw "${TOOLCHAIN_DIR}/Info.plist") && \
	echo "Using toolchain: $${TOOLCHAINS}" && \
	swift --version && \
	JAVASCRIPTKIT_EXPERIMENTAL_EMBEDDED_WASM=true \
		swift build \
			--toolchain "${TOOLCHAIN_DIR}" \
			--triple wasm32-unknown-none-wasm \
			-Xswiftc -Osize \
			-c release \
			--product WasmLib
	# Copy the Wasm module to website directory.
	cp .build/wasm32-unknown-none-wasm/release/WasmLib.wasm Web/app.wasm
	# Optimize the Wasm module.
	type -p wasm-opt && wasm-opt -Os --strip-debug Web/app.wasm -o Web/app.wasm || :
	# Copy the JavaScript glue code to website directory.
	mkdir -p Web/javascript-kit
	cp .build/checkouts/JavaScriptKit/Sources/JavaScriptKit/Runtime/index.mjs Web/javascript-kit/index.mjs
	chmod u+w Web/javascript-kit/index.mjs

# Launch a local web server to test the WebAssembly module.
serve:
	cd Web && \
	python3 -m http.server 8001
