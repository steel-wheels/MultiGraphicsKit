#
# Makefile
#

md4_dir = ../md4

include $(md4_dir)/Makefile.md4

DOCUMENT = MetalProgrammingBasics.md

all: $(DOCUMENT)
	mv $(DOCUMENT) $(DOCUMENT).tmp
	sed -e 's/@code_begin@/```/g' -e 's/@code_end@/```/g' \
		$(DOCUMENT).tmp > $(DOCUMENT)
	rm $(DOCUMENT).tmp

clean:
	(cd Fundamentals && make clean)
	(cd Tips && make clean)
	rm -f MetalProgrammingBasics.md
	
MetalProgrammingBasics.md4: \
	./Introduction/Introduction.md \
	./Fundamentals/Fundamentals.md \
	./Tips/Tips.md \
	./References/References.md

./Fundamentals/Fundamentals.md: dummy
	(cd Fundamentals && make)
	(cd Tips && make)

dummy:

