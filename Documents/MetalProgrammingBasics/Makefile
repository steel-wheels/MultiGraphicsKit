#
# Makefile
#

DOCUMENT = MetalProgrammingBasics.md

all: $(DOCUMENT)

clean:
	rm -f $(DOCUMENT)

$(DOCUMENT): MetalProgrammingBasics.md4
	md4 --output $@ $<

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
	Tips/Tips.md4 \
		Tips/ProgrammingTips.md4 \
	References/References.md4

