CC := gcc
CFLAGS := -std=c99 -O2 -Wall -Wextra -fPIC
BUILD_DIR := build

.PHONY: all clean build-c build-ada build-rust \
	test-c test-ada test-rust test-python test-all \
	test-c-a test-ada-a test-rust-a test-all-a \
	test-c-so test-ada-so test-rust-so test-python-so test-all-so

all: build-c build-ada build-rust

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

build-c: $(BUILD_DIR)
	$(CC) $(CFLAGS) -Iinclude -c c/c_lib.c -o $(BUILD_DIR)/c_lib.o
	rm -f $(BUILD_DIR)/libjp_c.a
	ar rcs $(BUILD_DIR)/libjp_c.a $(BUILD_DIR)/c_lib.o
	$(CC) -shared -o $(BUILD_DIR)/libjp_c.so $(BUILD_DIR)/c_lib.o

build-ada: $(BUILD_DIR)
	cd ada && gnatmake -c jp_ada.adb
	rm -f $(BUILD_DIR)/libjp_ada.a
	ar rcs $(BUILD_DIR)/libjp_ada.a ada/jp_ada.o
	$(CC) -shared -o $(BUILD_DIR)/libjp_ada.so ada/jp_ada.o -lgnat

build-rust: $(BUILD_DIR)
	cd rust && cargo build --release --lib
	cp rust/target/release/libjp_rust.a $(BUILD_DIR)/libjp_rust.a
	cp rust/target/release/libjp_rust.so $(BUILD_DIR)/libjp_rust.so

test-c: all
	$(CC) -std=c99 -O2 -Iinclude c/c_test.c c/c_wrappers.c -L$(BUILD_DIR) \
	  -Wl,-rpath,'$$ORIGIN' -ljp_c -ljp_ada -ljp_rust -o $(BUILD_DIR)/test_c
	LD_LIBRARY_PATH=$(BUILD_DIR) ./$(BUILD_DIR)/test_c

test-ada: all
	cd ada && gnatmake test_ada.adb -largs -L../$(BUILD_DIR) -Wl,-rpath,'$$ORIGIN' -ljp_c -ljp_ada -ljp_rust
	LD_LIBRARY_PATH=$(BUILD_DIR):ada ./ada/test_ada

test-rust: all
	cd rust && LD_LIBRARY_PATH=../$(BUILD_DIR) RUSTFLAGS="-L native=../$(BUILD_DIR) -l jp_c -l jp_ada -C link-arg=-Wl,-rpath,'$$ORIGIN/../build'" cargo run --release

test-python: all
	LD_LIBRARY_PATH=$(BUILD_DIR) python3 python/test_python.py

test-all: test-c test-ada test-rust test-python

test-c-a: all
	$(CC) -std=c99 -O2 -Iinclude c/c_test.c c/c_wrappers.c \
	  $(BUILD_DIR)/libjp_c.a $(BUILD_DIR)/libjp_ada.a $(BUILD_DIR)/libjp_rust.a \
	  -lgnat \
	  -o $(BUILD_DIR)/test_c_a
	./$(BUILD_DIR)/test_c_a

test-ada-a: all
	cd ada && gnatmake test_ada.adb -largs \
	  ../$(BUILD_DIR)/libjp_c.a ../$(BUILD_DIR)/libjp_ada.a ../$(BUILD_DIR)/libjp_rust.a
	./ada/test_ada

test-rust-a: all
	cd rust && RUSTFLAGS="-L native=../$(BUILD_DIR) -l static=jp_c -l static=jp_ada -l gnat" cargo run --release

test-all-a: test-c-a test-ada-a test-rust-a

test-c-so: all
	$(CC) -std=c99 -O2 -Iinclude c/c_test.c c/c_wrappers.c -L$(BUILD_DIR) \
	  -Wl,-rpath,'$$ORIGIN' -l:libjp_c.so -l:libjp_ada.so -l:libjp_rust.so -o $(BUILD_DIR)/test_c_so
	LD_LIBRARY_PATH=$(BUILD_DIR) ./$(BUILD_DIR)/test_c_so

test-ada-so: all
	cd ada && gnatmake test_ada.adb -largs -L../$(BUILD_DIR) -Wl,-rpath,'$$ORIGIN' \
	  -l:libjp_c.so -l:libjp_ada.so -l:libjp_rust.so
	LD_LIBRARY_PATH=$(BUILD_DIR):ada ./ada/test_ada

test-rust-so: all
	cd rust && LD_LIBRARY_PATH=../$(BUILD_DIR) \
	  RUSTFLAGS="-L native=../$(BUILD_DIR) -l dylib=jp_c -l dylib=jp_ada -C link-arg=-Wl,-rpath,'$$ORIGIN/../build'" \
	  cargo run --release

test-python-so: all
	LD_LIBRARY_PATH=$(BUILD_DIR) python3 python/test_python.py

test-all-so: test-c-so test-ada-so test-rust-so test-python-so

clean:
	rm -rf $(BUILD_DIR)
	rm -f ada/*.ali ada/*.o ada/test_ada
	cd rust && cargo clean