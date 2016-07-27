# Copyright 2016 The Kubernetes Authors. All rights reserved#
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License..
#

OUT_DIR = build
PACKAGE = k8s.io/contrib/kubelet-to-gcm
PREFIX = gcr.io/qlee-experiment
TAG = 1.0

# Rules for building the real image for deployment to gcr.io

deps:
		go get -u github.com/tools/godep

compile: k8s-slack-bot/ deps
		GOOS=linux GOARCH=amd64 CGO_ENABLED=0 godep go build -a -o $(OUT_DIR)/k8s-slack-bot k8s-slack-bot/main/daemon.go

test: monitor/
		godep go test ${PACKAGE}/k8s-slack-bot -v

go: compile test

clean:
	rm -rf build

build: go
	docker build -t ${PREFIX}/k8s-slack-bot:$(TAG) .

docker: build

push: docker
	gcloud docker push ${PREFIX}/k8s-slack-bot:$(TAG)
