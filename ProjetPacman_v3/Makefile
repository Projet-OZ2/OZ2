all: gui input playermanager pacman main run
playermanager:
	ozc -c PlayerManager.oz
gui:
	ozc -c GUI.oz
input:
	ozc -c Input.oz
main:
	ozc -c Main.oz
pacman:
	ozc -c Pacman103fred.oz
ghost:
	ozc -c Ghost103vincent.oz
run:
	@echo "Game launched"
	ozengine Main.ozf
clean:
	rm *.ozf
