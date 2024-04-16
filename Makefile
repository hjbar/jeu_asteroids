default: clean fmt build clear

build:
	dune build
	dune build @sdl

clean:
	dune clean

fmt:
	dune fmt

clear:
	clear

exec:
	dune exec prog/game_sdl.exe

mrproper:
	clean
