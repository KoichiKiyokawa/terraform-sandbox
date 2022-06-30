export IMAGE_TAG=`git rev-parse HEAD | cut -c 1-7`-`date '+%Y%m%d-%H%M'`
terraform apply --auto-approve -var "image-tag=${IMAGE_TAG}"
