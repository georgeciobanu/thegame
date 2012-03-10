PROJECT_ROOT=$(shell pwd)
PROJECT_NAME=theapp

run:
	@echo "Building with Titanium..."
	@mkdir -p ${PROJECT_ROOT}/${PROJECT_NAME}/build/iphone/
	@PROJECT_NAME=${PROJECT_NAME} PROJECT_ROOT=${PROJECT_ROOT} DEVICE_TYPE=iphone bash ${PROJECT_ROOT}/titanium.sh
clean:
	rm -rf theapp/build/