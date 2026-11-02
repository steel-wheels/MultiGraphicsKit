#
# Makefile
#

md4_dir = ../../md4

include $(md4_dir)/Makefile.md4

DOCUMENT = Fundamentals.md

all: $(DOCUMENT)

clean:
	rm -f $(DOCUMENT) BasicSequence.md \
		DataStructure.md

Fundamentals.md: \
	DataStructure.md \
	Pipeline.md \
	SoftwareComponents.md

DataStructure.md: Vertex.md \
	Viewport.md

dummy:

