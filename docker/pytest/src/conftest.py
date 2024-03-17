import pytest
import json

@pytest.fixture
def config():
    with open("/data/test-content") as file:
        config = json.load(file)
        print("   Done")
        return config

