set -ex

cd `dirname $0`

pushd ../
  docker build --platform linux/amd64 . -t $IMAGE_NAME
  docker push $IMAGE_NAME
popd