DOCKERID=$1

services=(
  "comments"
  "event-bus"
  "moderation"
  "posts"
  "query"
)

INFRA_ROOT=$(pwd)

for service in "${services[@]}"
do
  echo "Deploying $service"
  cd "$INFRA_ROOT/../$service" || exit
  tsc
  docker build -t "$DOCKERID"/"$service" .
  docker push "$DOCKERID"/"$service"
  cd ../infra/k8s || exit
  kubectl apply -f "$service"-depl.yaml
  kubectl rollout restart deployment "$service-depl"
done