.PHONY:clean

local:
	hugo -D server
clean:
	rm -rf  ./public
	rm -rf  ./resources