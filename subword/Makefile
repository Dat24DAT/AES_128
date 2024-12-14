design_name = subword
build: clean_build
	cd ./sim/work && vsim -c -do ../script/run.do
sim:
	cd ./sim/work && vsim $(design_name).wlf -do ../script/add_wave.do
clean_build:
	cd ./sim/work && del /Q *
clean: clean_build 
.PHONY: clean_build 