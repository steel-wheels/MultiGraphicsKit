#
# Makefile
#

md4_dir = ../md4

include $(md4_dir)/Makefile.md4

DOCUMENT = MetalProgrammingBasics.md

all: subdir $(DOCUMENT) images

clean:
	(cd Fundamentals && make clean)
	(cd Tips && make clean)
	rm -f MetalProgrammingBasics.md

subdir: dummy
	(cd Fundamentals && make)
	(cd Tips && make)

images: dummy
	cp Fundamentals/Images/* Images

$(DOCUMENT): MetalProgrammingBasics_.md
	sed -e 's/@code_begin@/```/g' -e 's/@code_end@/```/g' $< > $@

MetalProgrammingBasics_.md: \
	./MetalProgrammingBasics_.md4 \
	./Introduction/Introduction.md \
	./Fundamentals/Fundamentals.md \
	./Tips/Tips.md \
	./References/References.md

dummy:

