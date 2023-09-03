-include ../config/do.mk

DO_what=      Kak
DO_copyright= Copyright (c) 2023 Tim Menzies, BSD-2.
DO_repos=     . ../config ../data 

install: ## load python3 packages (requires `pip3`)
	 pip3 install -qr requirements.txt



../data:
	(cd ..; git clone https://github.com/4src/data data)

../config:
	(cd ..; git clone https://github.com/4src/config config)

############################
