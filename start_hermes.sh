#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: start_hermes.sh [--model-profile NAME] [--model MODEL_CHOSEN] [--kitty] [--no-kitty] [--no-llama] [--cwd PATH]

Starts a selectable local llama.cpp model and launches Hermes in the existing
bubblewrap sandbox.

Options:
  --model-profile NAME  Model profile from ~/scripts/hermes-local-models.yaml
  --model MODEL_CHOSEN  Relative path to a .gguf model under ~/models
  --kitty               Force opening Kitty
  --no-kitty            Run in the current terminal instead of opening Kitty
  --no-llama            Do not start llama-server; only point Hermes at endpoint
  --cwd PATH            Working directory inside the sandbox; default /app
  -h, --help            Show this help
USAGE
}

MODEL_PROFILE=""
MODEL_CHOSEN=""
LAUNCH_MODE="auto"
START_LLAMA=1
SANDBOX_CWD="/app"
MODEL_MANIFEST="${HOME}/scripts/hermes-local-models.yaml"
SELECT_HELPER="${HOME}/scripts/hermes_model_select.sh"
#LLAMA_SERVER_BIN="${HOME}/build/llama.cpp/build/bin/llama-server"
LLAMA_SERVER_BIN="/usr/bin/llama-server"
HERMES_BIN="/opt/hermes-agent/venv/bin/hermes"
HERMES_HOME_DIR="${HOME}/.hermes"
HERMES_LOG_DIR="${HERMES_HOME_DIR}/logs"
MODELS_DIR="${HOME}/models"
HERMES_APP_DIR="${HOME}/ChipChirp_Vault/Hermes-Agent"

while [ "$#" -gt 0 ]; do
  case "$1" in
    --model-profile)
      MODEL_PROFILE="${2:?--model-profile requires a name}"
      shift 2
      ;;
    --model)
      MODEL_CHOSEN="${2:?--model requires a model path relative to ~/models}"
      shift 2
      ;;
    --kitty)
      LAUNCH_MODE="kitty"
      shift
      ;;
    --no-kitty)
      LAUNCH_MODE="terminal"
      shift
      ;;
    --no-llama)
      START_LLAMA=0
      shift
      ;;
    --cwd)
      SANDBOX_CWD="${2:?--cwd requires a path}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

list_models() {
  find "$MODELS_DIR" -type f -name '*.gguf' -printf '  %P\n' | sort
}

select_profile_model() {
  if [ ! -x "$SELECT_HELPER" ]; then
    echo "Missing selector helper: $SELECT_HELPER" >&2
    exit 1
  fi

  # shellcheck disable=SC1090
  eval "$("$SELECT_HELPER" "$MODEL_MANIFEST" "$MODEL_PROFILE")"
}

select_chosen_model() {
  if [[ "$MODEL_CHOSEN" = /* ]] || [[ "$MODEL_CHOSEN" == ".." ]] || [[ "$MODEL_CHOSEN" == ../* ]] || [[ "$MODEL_CHOSEN" == */.. ]] || [[ "$MODEL_CHOSEN" == */../* ]]; then
    echo "--model must be a relative path under ~/models" >&2
    exit 2
  fi

  HERMES_LOCAL_MODEL_PATH="${HOME}/models/${MODEL_CHOSEN}"

  if [[ "$HERMES_LOCAL_MODEL_PATH" != *.gguf ]] || [ ! -f "$HERMES_LOCAL_MODEL_PATH" ]; then
    echo "Model file does not exist under ~/models: ${MODEL_CHOSEN}" >&2
    echo "Available .gguf models:" >&2
    list_models >&2
    exit 1
  fi

  HERMES_LOCAL_PROFILE="${MODEL_PROFILE:-local-gguf}"
  HERMES_LOCAL_LABEL="${MODEL_CHOSEN}"
  HERMES_LOCAL_MODEL_NAME="$(basename "$MODEL_CHOSEN" .gguf)"
  HERMES_LOCAL_HOST="127.0.0.1"
  HERMES_LOCAL_PORT="8080"
  HERMES_LOCAL_CONTEXT="65536"
  HERMES_LOCAL_NGL="999"
  HERMES_LOCAL_EXTRA_ARGS=""
}

if [ -n "$MODEL_CHOSEN" ]; then
  select_chosen_model
else
  select_profile_model
fi

LLAMA_ENDPOINT="http://${HERMES_LOCAL_HOST}:${HERMES_LOCAL_PORT}/v1"
HEALTH_ENDPOINT="http://${HERMES_LOCAL_HOST}:${HERMES_LOCAL_PORT}/health"
LLAMA_PID=""

cleanup() {
  if [ -n "${LLAMA_PID}" ] && kill -0 "$LLAMA_PID" 2>/dev/null; then
    echo "[*] Stopping llama-server PID ${LLAMA_PID}"
    kill "$LLAMA_PID" 2>/dev/null || true
    wait "$LLAMA_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT INT TERM

wait_for_llama() {
  echo "[*] Waiting for llama-server health endpoint: ${HEALTH_ENDPOINT}"
  for _ in $(seq 1 60); do
    if curl -sf "$HEALTH_ENDPOINT" >/dev/null 2>&1; then
      echo "[*] llama-server is ready"
      return 0
    fi
    sleep 1
  done
  echo "[!] llama-server did not become healthy" >&2
  return 1
}

start_llama() {
  if [ ! -x "$LLAMA_SERVER_BIN" ]; then
    echo "Missing llama-server binary: $LLAMA_SERVER_BIN" >&2
    exit 1
  fi

  if curl -sf "$HEALTH_ENDPOINT" >/dev/null 2>&1; then
    echo "[*] Reusing existing llama-server at ${LLAMA_ENDPOINT}"
    return 0
  fi

  echo "[*] Starting ${HERMES_LOCAL_LABEL} on ${LLAMA_ENDPOINT}"
  if should_capture_llama_output; then
    mkdir -p "$HERMES_LOG_DIR"
    local llama_log="${HERMES_LOG_DIR}/llama-server-${HERMES_LOCAL_PROFILE}.log"
    echo "[*] llama-server output: ${llama_log}"
    # Intentional word splitting for HERMES_LOCAL_EXTRA_ARGS, generated quoted by helper.
    # shellcheck disable=SC2086
    "$LLAMA_SERVER_BIN" \
      -m "$HERMES_LOCAL_MODEL_PATH" \
      -c "$HERMES_LOCAL_CONTEXT" \
      --host "$HERMES_LOCAL_HOST" \
      --port "$HERMES_LOCAL_PORT" \
      -ngl "$HERMES_LOCAL_NGL" \
      $HERMES_LOCAL_EXTRA_ARGS >"$llama_log" 2>&1 &
  else
    # Intentional word splitting for HERMES_LOCAL_EXTRA_ARGS, generated quoted by helper.
    # shellcheck disable=SC2086
    "$LLAMA_SERVER_BIN" \
      -m "$HERMES_LOCAL_MODEL_PATH" \
      -c "$HERMES_LOCAL_CONTEXT" \
      --host "$HERMES_LOCAL_HOST" \
      --port "$HERMES_LOCAL_PORT" \
      -ngl "$HERMES_LOCAL_NGL" \
      $HERMES_LOCAL_EXTRA_ARGS &
  fi
  LLAMA_PID=$!
  echo "[*] llama-server PID: ${LLAMA_PID}"
  wait_for_llama
}

configure_hermes_endpoint() {
  mkdir -p "$HERMES_HOME_DIR"
  hermes config set model.provider custom
  hermes config set model.default "$HERMES_LOCAL_MODEL_NAME"
  hermes config set model.base_url "$LLAMA_ENDPOINT"
}

check_sandbox_paths() {
  if [ ! -x "$HERMES_BIN" ]; then
    echo "Missing Hermes executable: $HERMES_BIN" >&2
    exit 1
  fi

  if [ ! -d "$HERMES_APP_DIR" ]; then
    echo "Missing Hermes app directory: $HERMES_APP_DIR" >&2
    exit 1
  fi
}

is_ssh_session() {
  [ -n "${SSH_CONNECTION:-}" ] || [ -n "${SSH_CLIENT:-}" ] || [ -n "${SSH_TTY:-}" ]
}

should_capture_llama_output() {
  is_ssh_session
}

should_launch_kitty() {
  case "$LAUNCH_MODE" in
    kitty)
      if ! command -v kitty >/dev/null 2>&1; then
        echo "Kitty requested with --kitty, but kitty is not in PATH" >&2
        exit 1
      fi
      return 0
      ;;
    terminal)
      return 1
      ;;
    auto)
      ! is_ssh_session && command -v kitty >/dev/null 2>&1
      ;;
    *)
      echo "Unknown launch mode: $LAUNCH_MODE" >&2
      exit 2
      ;;
  esac
}

warn_missing_display() {
  if is_ssh_session && [ -z "${DISPLAY:-}" ]; then
    echo "[!] DISPLAY is not set in this SSH session; reconnect with ssh -Y or ssh -X for X11 forwarding." >&2
  fi
}

run_bwrap_hermes() {
  local gui_args=()
  local xauthority="${XAUTHORITY:-${HOME}/.Xauthority}"

  if [ -n "${DISPLAY:-}" ]; then
    gui_args+=(--setenv DISPLAY "$DISPLAY")
    gui_args+=(--ro-bind-try /tmp/.X11-unix /tmp/.X11-unix)

    if [ -e "$xauthority" ]; then
      gui_args+=(--ro-bind "$xauthority" "$xauthority")
      gui_args+=(--setenv XAUTHORITY "$xauthority")
    fi
  fi

  bwrap \
    --unshare-all --share-net \
    --new-session \
    --die-with-parent \
    --dir /home \
    --dir /home/amber \
    --proc /proc \
    --dev /dev \
    --tmpfs /tmp \
    --setenv LANG C.UTF-8 \
    --setenv LC_ALL C.UTF-8 \
    --ro-bind /usr /usr \
    --ro-bind /etc /etc \
    --ro-bind /bin /bin \
    --ro-bind /opt/hermes-agent /opt/hermes-agent \
    --ro-bind /sbin /sbin \
    --ro-bind /lib /lib \
    --ro-bind /lib64 /lib64 \
    "${gui_args[@]}" \
    --ro-bind /home/amber/models /home/amber/models \
    --bind /home/amber/ChipChirp_Vault/Hermes-Agent /app \
    --bind /home/amber/build /home/amber/build \
    --bind /home/amber/proj /home/amber/proj \
    --bind-try /home/amber/game /home/amber/game \
    --bind /home/amber/.hermes /home/amber/.hermes \
    --chdir "$SANDBOX_CWD" \
    "$HERMES_BIN" chat
}

main() {
  echo "[*] Selected profile: ${HERMES_LOCAL_PROFILE} (${HERMES_LOCAL_LABEL})"
  if [ "$START_LLAMA" -eq 1 ]; then
    start_llama
  fi
  configure_hermes_endpoint
  check_sandbox_paths
  warn_missing_display

  if should_launch_kitty; then
    kitty --title "Hermes-Local:${HERMES_LOCAL_PROFILE}" env \
      SANDBOX_CWD="$SANDBOX_CWD" \
      HERMES_BIN="$HERMES_BIN" \
      DISPLAY="${DISPLAY:-}" \
      XAUTHORITY="${XAUTHORITY:-}" \
      bash -lc "$(declare -f run_bwrap_hermes); run_bwrap_hermes"
  else
    run_bwrap_hermes
  fi
}

main "$@"
