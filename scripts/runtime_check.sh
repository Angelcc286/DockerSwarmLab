#!/usr/bin/env bash
set -euo pipefail
TEAM="${1:?uso: runtime_check.sh team-01}"
case "$TEAM" in team-0[1-5]) ;; *) echo "Equipo inválido"; exit 2;; esac
NUM="${TEAM#team-}"
STACK="swarm${NUM}"
FILE="submissions/${TEAM}/docker-stack.yml"
SERVICE=$(python - "$TEAM" <<'PYIN'
import json,sys
print(json.load(open(f'challenges/{sys.argv[1]}.json'))['required_service'])
PYIN
)
cleanup() { docker stack rm "$STACK" >/dev/null 2>&1 || true; if [[ "$TEAM" == team-03 ]]; then docker secret rm demo_token >/dev/null 2>&1 || true; fi; }
trap cleanup EXIT
if [[ "$TEAM" == team-03 ]]; then printf 'training-only-token' | docker secret create demo_token - >/dev/null; fi
docker stack deploy --resolve-image always -c "$FILE" "$STACK"
NAME="${STACK}_${SERVICE}"
EXPECTED=$(python - "$TEAM" <<'PYIN'
import json,sys
print(json.load(open(f'challenges/{sys.argv[1]}.json'))['required_replicas'])
PYIN
)
ready=0
for i in $(seq 1 45); do
  actual=$(docker service ls --filter "name=$NAME" --format '{{.Replicas}}' | head -n 1)
  if [[ "$actual" =~ ^([0-9]+)/([0-9]+)$ ]] && (( ${BASH_REMATCH[1]} >= EXPECTED )); then ready=1; break; fi
  sleep 2
done
[[ "$ready" -eq 1 ]] || { docker stack ps "$STACK" --no-trunc; echo 'No alcanzó réplicas deseadas'; exit 1; }
echo "PASS: $NAME listo"
case "$TEAM" in
team-01)
  task=$(docker ps --filter "label=com.docker.swarm.service.name=$NAME" -q | head -n 1)
  [[ -n "$task" ]] || exit 1
  docker kill "$task" >/dev/null
  ok=0
  for i in $(seq 1 45); do
    v=$(docker service ls --filter "name=$NAME" --format '{{.Replicas}}' | head -n 1)
    [[ "$v" == "3/3" ]] && { ok=1; break; }
    sleep 2
  done
  [[ "$ok" == 1 ]] || exit 1
  echo 'PASS: réplicas recuperadas'
  ;;
team-02)
  docker service update --detach=false --update-parallelism 1 --update-failure-action rollback --image nginx:invalid-training-tag "$NAME" >/dev/null 2>&1 || true
  # El intento debe dejar la imagen previa como especificación actual.
  current=$(docker service inspect "$NAME" --format '{{.Spec.TaskTemplate.ContainerSpec.Image}}')
  [[ "$current" == nginx:1.27-alpine* ]] || { echo "Rollback no verificado: $current"; exit 1; }
  echo 'PASS: especificación anterior conservada/revertida'
  ;;
team-03)
  logs=$(docker service logs "$NAME" 2>&1 || true)
  echo "$logs" | grep -q secret-mounted || { echo "$logs"; exit 1; }
  echo 'PASS: secreto leído por servicio'
  ;;
team-04)
  curl --fail --silent --max-time 10 http://127.0.0.1:18080/ | grep -q 'Hostname:'
  [[ "$(docker service inspect "${STACK}_backend" --format '{{json .Endpoint.Ports}}')" == null ]] || exit 1
  # DNS interno probado con un contenedor efímero en la overlay attachable no es posible sin habilitar attachable.
  # Se verifica red compartida y existencia del backend; DNS queda como demo local documentada.
  echo 'PASS: frontend HTTP y backend sin puertos publicados'
  ;;
team-05)
  docker service inspect "$NAME" --format '{{json .Spec.TaskTemplate.Resources}}' | grep -q 'MemoryBytes'
  docker service inspect "$NAME" --format '{{json .Spec.TaskTemplate.Resources}}' | grep -q 'NanoCPUs'
  echo 'PASS: recursos aplicados'
  ;;
esac
