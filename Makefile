TOOLCHAIN_DIR := ${HOME}/Library/Developer/Toolchains/swift-latest.xctoolchain

# Build instructions adapted from Max Desiatov:
# https://forums.swift.org/t/some-feedback-from-my-short-experience-with-swiftwasm/69605/5

wasmlib:  
	echo "Using toolchain dir: ${TOOLCHAIN_DIR}"
	export TOOLCHAINS=$$(plutil -extract CFBundleIdentifier raw "${TOOLCHAIN_DIR}/Info.plist") && \
	echo "Using toolchain: $${TOOLCHAINS}" && \
	swift --version && \
	swiftc \
		-Osize \
		-Xcc -fdeclspec \
		-target wasm32-unknown-none-wasm \
		-enable-experimental-feature Extern \
		-enable-experimental-feature Embedded \
		-wmo \
		Sources/main.swift -c -o main.o
	"${TOOLCHAIN_DIR}/usr/bin/wasm-ld" --no-entry main.o -o Web/app.wasm