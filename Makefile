.EXPORT_ALL_VARIABLES:

.PHONY: install-tools install-deps gen-static check build

GO111MODULE=on

default: build

install-tools:
	@if [ ! -f $(GOPATH)/bin/esc ]; then \
		echo "installing esc..."; \
		go get -u github.com/mjibson/esc; \
	fi
	@if [ ! -f $(GOPATH)/bin/golangci-lint ]; then \
		echo "installing golangci-lint..."; \
		curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s -- -b $(GOPATH)/bin v1.18.0; \
	fi
	@if [ ! -f $(GOPATH)/bin/gothanks ]; then \
		echo "installing gothanks..."; \
		go get -u github.com/psampaz/gothanks; \
	fi

install-deps:
	go get .

gen-static: install-tools
	go generate main.go

check: install-tools
	golangci-lint run ./...

thanks: install-tools
	$(GOPATH)/bin/gothanks -y | grep -v "is already"

build:
	go build .

build-linux-amd64:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build .

dockerize:
	docker build -t ccamel/go-graphql-subscription-example .
