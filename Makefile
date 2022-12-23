-include env_make


REGISTRY=bowens
REPO_BASE=docker-iac-build

# The "BUILD_NUMBER" in CI will be composed of the CI build number and branch under the current construct.
ifeq ($(BUILD_NUMBER),)
	BUILD_NUMBER ?= "none"
endif


APP_REPO = ${REGISTRY}/${REPO_BASE}

# This creates the Git shorthash we use for tagging.
ifeq ($(COMMIT_SHA),)
	COMMIT_SHA ?= $(shell git log -1 --pretty=format:"%h")
endif

DOCKER_TAG = ${BUILD_NUMBER}-${COMMIT_SHA}

.PHONY: build release clean
default: build

build:
	docker build -f Dockerfile \
	  --no-cache \
	  -t $(APP_REPO):$(DOCKER_TAG) ./
	docker tag $(APP_REPO):$(DOCKER_TAG) $(APP_REPO):latest

release:
	docker build -f Dockerfile \
	  --no-cache \
	  -t $(APP_REPO):$(DOCKER_TAG) ./
	docker tag $(APP_REPO):$(DOCKER_TAG) $(APP_REPO):latest
	docker push $(APP_REPO):$(DOCKER_TAG)

clean:
	docker rmi -f $(APP_REPO):latest
	docker rmi -f $(APP_REPO):$(DOCKER_TAG)


