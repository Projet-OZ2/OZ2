all: gui input playermanager pacman main
playermanager:
	ozc -c PlayerManager.oz
gui:
	ozc -c GUI.oz
input:
	ozc -c Input.oz
main:
	ozc -c Main.oz
pacman:
	ozc -c Pacman001rene.oz
	ozc -c Pacman002fred.oz
ghost:
	ozc -c Ghost001rene.oz
run:
	@echo "launch game"
	ozengine Main.ozf
clean:
	rm *.ozf
