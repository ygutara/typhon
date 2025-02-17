

.PHONY: clean all init generate generate_mocks

all: build/main

build/main: cmd/main.go generated
	@echo "Building..."
	go build -o $@ $<

clean:
	rm -rf generated

init: clean generate
	go mod tidy

test:
	go clean -testcache
	go test -short -coverprofile coverage.out -short -v ./...

test_api:
	go clean -testcache
	go test ./tests/...

generate: generated generate_mocks generate_uc_mocks

coverage :
	@echo "\x1b[32;1m>>> running unit test and calculate coverage \x1b[0m"
	if [ -f coverage.txt ]; then rm coverage.txt; fi;
	@echo "mode: atomic" > coverage.txt

	@go test -short ./...  -cover -coverprofile=coverage.txt -covermode=count \
		-coverpkg=$$(go list ./...  | grep -v generated | tr '\n' ',')
	@go tool cover -func=coverage.txt

generated: api.yml
	@echo "Generating files..."
	mkdir internal/generated || true
	oapi-codegen --package generated -generate types,server,spec $< > internal/generated/api.gen.go

INTERFACES_GO_FILES := $(shell find internal/repository -name "interfaces.go")
INTERFACES_GEN_GO_FILES := $(INTERFACES_GO_FILES:%.go=%.mock.gen.go)

generate_mocks: $(INTERFACES_GEN_GO_FILES)
$(INTERFACES_GEN_GO_FILES): %.mock.gen.go: %.go
	@echo "Generating mocks $@ for $<"
	mockgen -source=$< -destination=$@ -package=$(shell basename $(dir $<))

INTERFACES_UC_GO_FILES := $(shell find internal/usecase -name "interfaces.go")
INTERFACES_UC_GEN_GO_FILES := $(INTERFACES_UC_GO_FILES:%.go=%.mock.gen.go)

generate_uc_mocks: $(INTERFACES_UC_GEN_GO_FILES)
$(INTERFACES_UC_GEN_GO_FILES): %.mock.gen.go: %.go
	@echo "Generating mocks $@ for $<"
	mockgen -source=$< -destination=$@ -package=$(shell basename $(dir $<))