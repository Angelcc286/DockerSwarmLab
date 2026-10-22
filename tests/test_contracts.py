import json
from pathlib import Path
import pytest
import yaml

ROOT = Path(__file__).resolve().parents[1]

@pytest.fixture
def ctx(team):
    assert team in {f"team-{n:02d}" for n in range(1, 6)}
    contract = json.loads((ROOT / "challenges" / f"{team}.json").read_text())
    path = ROOT / "submissions" / team / "docker-stack.yml"
    stack = yaml.safe_load(path.read_text())
    assert isinstance(stack, dict)
    return contract, stack

def test_files_present(team):
    base = ROOT / "submissions" / team
    for name in ("docker-stack.yml", "evidence.md", "presentation.md"):
        assert (base / name).is_file(), name

def test_service_and_image(ctx):
    c, s = ctx
    svc = s["services"][c["required_service"]]
    assert svc["image"] == c["required_image"]
    assert svc["deploy"]["replicas"] >= c["required_replicas"]

def test_mission_contract(ctx):
    c, s = ctx
    feature = c["feature"]
    svc = s["services"][c["required_service"]]
    dep = svc["deploy"]
    if feature == "resilience":
        assert dep["restart_policy"]["condition"] == "on-failure"
        assert "healthcheck" in svc
        assert "memory" in dep["resources"]["limits"]
    elif feature == "updates":
        u = dep["update_config"]
        assert u["parallelism"] == 1
        assert u["failure_action"] == "rollback"
        assert u.get("monitor") and dep.get("rollback_config")
        assert "healthcheck" in svc
    elif feature == "secrets":
        assert "demo_token" in svc["secrets"]
        assert s["secrets"]["demo_token"]["external"] is True
        assert not svc.get("ports")
        assert "demo_token" not in str(svc.get("environment", {}))
    elif feature == "network":
        assert s["networks"]["private_net"]["driver"] == "overlay"
        assert svc.get("ports")
        backend = s["services"]["backend"]
        assert not backend.get("ports")
        assert "private_net" in svc["networks"] and "private_net" in backend["networks"]
    elif feature == "resources":
        assert "healthcheck" in svc
        assert dep["restart_policy"]["condition"] == "on-failure"
        r = dep["resources"]
        for k in ("limits", "reservations"):
            assert "cpus" in r[k] and "memory" in r[k]

def test_documentation(team):
    base = ROOT / "submissions" / team
    evidence = (base / "evidence.md").read_text()
    presentation = (base / "presentation.md").read_text()
    assert len(evidence.strip()) > 450, "Documentar resultados, no solo plantilla"
    assert len(presentation.strip()) > 200, "Completar guion de presentación"
    assert "# completar" not in evidence
