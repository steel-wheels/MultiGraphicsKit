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

$(DOCUMENT): DataStructure.md \
	     SoftwareComponents.md \
	     BasicSequence.md

DataStructure.md4: Vertex.md

dummy:

