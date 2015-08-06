SHELL=/bin/bash
# for experiments on multiple datasets and language-pairs

DIRS=en-cs en-es en-nl cs-en es-en nl-en
#SETS=batch1? batch2? news
SETS=batch2?

PARAMS=fl_agreement={0,AM-P,GM-P,HM-P,HM-Log-P,GM-Log-P}

help:
	#see the Makefile

go:
	for DIR in $(DIRS); do \
	  for SET in $(SETS); do \
	    [ -d $$DIR/$$SET ] && ( cd $$DIR/$$SET; \
	      for PARAM in $(PARAMS); do \
	        echo ======= $$DIR/$$SET PARAMS=$$PARAM; \
	        make translate eval PARAMS=$$PARAM >>multi.log 2>&1; \
	      done; \
	    ) & \
	  done;\
	done;