#!/bin/sh
set -euxo pipefail

echo '::group::Attempt to login docker registry'
if ! echo "${INPUT_GCR_AUTH_KEY}" | docker login -u _json_key --password-stdin https://${INPUT_REGISTRY}; then
    echo 'Failed to login to docker registry'
    exit 1
fi
echo '::endgroup::'
echo '::group::Build docker image'
build_args=''
file_arg=''
[[ ! -z $INPUT_DOCKERFILE ]] && file_arg="--file ${INPUT_DOCKERFILE}"
if [[ ! -z "${INPUT_BUILD_ARGS}" ]]; then
    for arg in $(echo "${INPUT_BUILD_ARGS}" | tr ',' '\n'); do
        build_args="${build_args} --build-arg ${arg}"
    done
fi
if ! docker build ${build_args} -t ${INPUT_IMAGE} ${file_arg} ${INPUT_CONTEXT}; then
    echo 'Failed to build docker image'
    exit 1
fi
echo '::endgroup::'
echo '::group::Push docker image to the registry'
for tag in $(echo "${INPUT_TAGS}" | tr ',' '\n'); do
    target_image="${INPUT_REGISTRY}/${INPUT_PROJECT_ID}/${INPUT_IMAGE}:${tag}"
    docker tag ${INPUT_IMAGE} ${target_image}
    if ! docker push ${target_image}; then
        echo 'Failed to push docker image'
        exit 1
    fi
done
echo '::endgroup::'
