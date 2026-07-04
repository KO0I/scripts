#!/usr/bin/env bash
set -euo pipefail

SELECTOR="${1:-${HOME}/scripts/hermes-local-models.yaml}"
PROFILE="${2:-}"

python3 - "$SELECTOR" "$PROFILE" <<'PY'
import shlex
import sys
from pathlib import Path

selector = Path(sys.argv[1]).expanduser()
requested = sys.argv[2]


def emit(assignments):
    for key, value in assignments.items():
        print(f'export {key}={shlex.quote(str(value))}')


def emit_model_path(model_path, profile='local-gguf'):
    model_path = model_path.expanduser()
    if not model_path.exists() or not model_path.is_file():
        raise SystemExit(f'Model file does not exist: {model_path}')
    if model_path.suffix != '.gguf':
        raise SystemExit(f'Model file must end in .gguf: {model_path}')

    emit({
        'HERMES_LOCAL_PROFILE': profile,
        'HERMES_LOCAL_LABEL': model_path.name,
        'HERMES_LOCAL_MODEL_PATH': model_path,
        'HERMES_LOCAL_MODEL_NAME': model_path.stem,
        'HERMES_LOCAL_PORT': '8080',
        'HERMES_LOCAL_CONTEXT': '65536',
        'HERMES_LOCAL_NGL': '999',
        'HERMES_LOCAL_HOST': '127.0.0.1',
        'HERMES_LOCAL_EXTRA_ARGS': '',
    })


if selector.is_dir():
    matches = sorted(selector.rglob('*.gguf'))
    if requested:
        selected = selector / requested
        emit_model_path(selected, selector.name)
        raise SystemExit(0)
    if not matches:
        raise SystemExit(f'No .gguf models found under: {selector}')
    if len(matches) > 1:
        names = '\n'.join(f'  {path.relative_to(selector)}' for path in matches)
        raise SystemExit(f'Multiple .gguf models found under {selector}. Pass one as the second argument:\n{names}')
    emit_model_path(matches[0], selector.name)
    raise SystemExit(0)

if selector.is_file() and selector.suffix == '.gguf':
    emit_model_path(selector)
    raise SystemExit(0)

try:
    import yaml
except ImportError as exc:
    raise SystemExit('Missing PyYAML. Install with: python3 -m pip install --user pyyaml') from exc

manifest = selector
data = yaml.safe_load(manifest.read_text())
models = data.get('models') or {}
profile = requested or data.get('default')
if profile not in models:
    names = ', '.join(sorted(models))
    raise SystemExit(f'Unknown model profile {profile!r}. Available: {names}')

cfg = models[profile]
required = ['model', 'hermes_model_name', 'port', 'context', 'ngl', 'host']
missing = [key for key in required if key not in cfg]
if missing:
    raise SystemExit(f'Model profile {profile!r} missing keys: {missing}')

model_path = Path(str(cfg['model'])).expanduser()
if not model_path.exists():
    raise SystemExit(f'Model file does not exist: {model_path}')

extra_args = cfg.get('extra_args') or []
if not isinstance(extra_args, list):
    raise SystemExit('extra_args must be a list')

assignments = {
    'HERMES_LOCAL_PROFILE': profile,
    'HERMES_LOCAL_LABEL': str(cfg.get('label', profile)),
    'HERMES_LOCAL_MODEL_PATH': str(model_path),
    'HERMES_LOCAL_MODEL_NAME': str(cfg['hermes_model_name']),
    'HERMES_LOCAL_PORT': str(cfg['port']),
    'HERMES_LOCAL_CONTEXT': str(cfg['context']),
    'HERMES_LOCAL_NGL': str(cfg['ngl']),
    'HERMES_LOCAL_HOST': str(cfg['host']),
    'HERMES_LOCAL_EXTRA_ARGS': ' '.join(shlex.quote(str(arg)) for arg in extra_args),
}

emit(assignments)
PY
