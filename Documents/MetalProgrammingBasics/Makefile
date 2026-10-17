#
# Makefile
#

md4_dir = ../md4

include $(md4_dir)/Makefile.md4

DOCUMENT = MetalProgrammingBasics.md

SECTIONS = \
	001-Introduction.md \
	002-SoftwareComponents.md \
	003-BasicSequence.md  \
	004-MetalLibrary.md \
	100-Tips.md \
	101-References.md

all: $(DOCUMENT)

clean:
	rm -f 003-BasicSequence.md 004-MetalLibrary.md

$(DOCUMENT): $(SECTIONS)
	cat $(SECTIONS) > $(DOCUMENT)

