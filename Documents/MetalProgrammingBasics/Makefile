#
# Makefile
#

DOCUMENT = MetalProgrammingBasics.md
LIBDIR0  = ../../Resource/Metal/
LIBDIR1	 = ../../Source/Bridge

all: $(DOCUMENT)

clean:
	rm -f $(DOCUMENT)

$(DOCUMENT): MetalProgrammingBasics.md4
	md4 --output $@ --include $(LIBDIR0) --include $(LIBDIR1) $<

MetalProgrammingBasics.md: \
	Introduction/Introduction.md4 \
	Fundamentals/Fundamentals.md4 \
		Fundamentals/DataStructure.md4 \
			Fundamentals/Vector.md4 \
			Fundamentals/Vertex.md4 \
			Fundamentals/Viewport.md4 \
			Fundamentals/Scaling.md4 \
		Fundamentals/Pipeline.md4 \
		Fundamentals/SoftwareComponents.md4 \
	Implementation/Implementation.md4 \
		Implementation/MetalLibrary.md4 \
	Tips/Tips.md4 \
		Tips/ProgrammingTips.md4 \
	References/References.md4

