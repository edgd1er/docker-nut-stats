#!/usr/bin/env bash
#
# build locally using buildx (need experimental: enabled in client docker config.json )
#

set -x
amend=""

isQemu=$(apt list -qq qemu-user-static | grep -c install)
if [[ $isQemu -eq 0 ]]; then
  sudo apt-get install -y qemu-user-static
  update-binfmts --version
  [[ $? -ne 0 ]] && echo -e "\nError binfmts is not installed" && exit 1 || echo
  #docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
  ls /proc/sys/fs/binfmt_misc/
  docker buildx rm amd-arm
  docker buildx create --use --name amd-arm --platform linux/arm64,linux/amd64,linux/arm/v7
  docker buildx inspect --bootstrap
fi

# build and push
docker buildx build --push --no-cache --platform linux/arm64,linux/amd64,linux/arm/v7 -t edgd1er/nut-stats:latest ./Build


isAbsent=$(docker manifest inspect edgd1er/nut-stats:latest | grep -c "no such manifest")
if [[ $isAbsent -ne 0 ]]; then
  amend=" --amend "
fi

#docker manifest create edgd1er/nut-stats:latest $amend edgd1er/nut-stats:amd64-latest $amend edgd1er/nut-stats:armv7
#docker manifest push edgd1er/nut-stats:latest
