# all targets are phony (no files to check)
.PHONY: default build clean install uninstall

default: build

build:
	echo "Building.."

clean:
	echo "Cleaning.."

install:
	echo "Installing.."

uninstall:
	echo "Uninstalling.."
