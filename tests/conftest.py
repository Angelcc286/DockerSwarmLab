import pytest

def pytest_addoption(parser):
    parser.addoption("--team", action="store", default="team-01")

@pytest.fixture
def team(request):
    return request.config.getoption("--team")
