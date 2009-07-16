OUTPUT := dropple.swf

ifdef DEBUG
DEBUG_FLAG := true
else
DEBUG_FLAG := false
endif

all:
	fcsh-wrap -optimize=true -output $(OUTPUT) -frames.frame arbitraryframename MainMenu -compiler.debug=$(DEBUG_FLAG) Preloader.as

clean:
	rm -f *~ $(OUTPUT)

.PHONY: all clean


