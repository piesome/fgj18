BUILD_DIR=.build
LOVE_FILE=.build/release/kylmäkuljetus.love
ZIP_TO_UPLOAD=upload.zip

all: $(ZIP_TO_UPLOAD)

.PHONY: .build
.build:
	mkdir -p .build/source/assets/fonts
	mkdir -p .build/source/assets/graphics
	mkdir -p .build/source/assets/music
	mkdir -p .build/source/assets/sfx
	sh -c 'for i in `git ls-files`; do cp $$i .build/source/$$i; done'

.PHONY: $(LOVE_FILE)
$(LOVE_FILE):
	rm -f $(LOVE_FILE)
	mkdir -p .build/release
	git ls-files | egrep -v ".*\.ase|.*\.xrns" | xargs zip -9 -r $(LOVE_FILE)

$(ZIP_TO_UPLOAD): $(LOVE_FILE) .build
	rm -f $(ZIP_TO_UPLOAD)
	zip -r upload.zip .build

.phony: clean
clean:
	rm -rf .build
