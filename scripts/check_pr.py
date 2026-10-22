import os
import subprocess
import sys

team = os.environ.get("TEAM", "")
if team not in {f"team-{n:02d}" for n in range(1, 6)}:
    sys.exit("TEAM inválido")
base = os.environ.get("BASE_SHA")
head = os.environ.get("HEAD_SHA")
if not base or not head:
    sys.exit("Faltan SHAs")
changed = subprocess.check_output(["git", "diff", "--name-only", f"{base}...{head}"], text=True).splitlines()
if not changed:
    sys.exit("PR sin cambios")
allowed = f"submissions/{team}/"
for path in changed:
    if not path.startswith(allowed) or path.split("/")[-1] not in {"docker-stack.yml", "evidence.md", "presentation.md"}:
        sys.exit(f"Archivo no autorizado en PR: {path}")
print("Archivos permitidos:", *changed, sep="\n- ")
