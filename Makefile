BUILD_DIR=.build
LOVE_FILE=.build/release/kylmäkuljetus.love

all: $(ZIP_TO_UPLOAD)

$(LOVE_FILE):
	mkdir -p .build/release
	find . | grep -v '.git' | grep -v '.build' | grep -v '.zip' | zip -9 -r $(LOVE_FILE) * -@

$(ZIP_TO_UPLOAD): $(LOVE_FILE)
	zip -r upload.zip .build

.phony: clean
clean:
	rm -rf .build
