SHELL=/bin/bash
# for experiments on multiple datasets and language-pairs

#DIRS=en-cs en-es en-nl cs-en es-en nl-en
DIRS=en-cs
#SETS=batch1? batch2? news
SETS=batch2? batch3?

#PARAMS=fl_agreement={0,AM-P,GM-P,HM-P,HM-Log-P,GM-Log-P}
PARAMS = hideIT=0__gazetteer=0 \
	 hideIT=1__gazetteer=0 \
	 hideIT=0__gazetteer=all \
	 hideIT=1__gazetteer=all

help:
	#see the Makefile

print_params:
	for PARAM in $(PARAMS); do \
	  PARAM=`echo $$PARAM | sed 's/__/ /g'`; \
	  echo PARAMS=\"$$PARAM\"; \
	done;

go:
	for DIR in $(DIRS); do \
	  for SET in $(SETS); do \
	    [ -d $$DIR/$$SET ] && ( cd $$DIR/$$SET; \
	      for PARAM in $(PARAMS); do \
	        PARAM=`echo $$PARAM | sed 's/__/ /g'`; \
	        echo ======= $$DIR/$$SET PARAMS=$$PARAM; \
	        make translate eval TREEX_FLAGS="--queue=troja-all.q" PARAMS="$$PARAM" >>multi.log 2>&1; \
	      done; \
	    ) & \
	  done;\
	done;