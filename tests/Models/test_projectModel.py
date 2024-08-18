# WARING : tests wrote by Copilot
import pytest
from Models.projectModel import ProjectModel
import tempfile
import json


@pytest.fixture
def project_file():
    data = [
        {"id": 1, "name": "Project 1", "description": "Description 1"},
        {"id": 2, "name": "Project 2", "description": "Description 2"},
    ]
    with tempfile.NamedTemporaryFile(mode="w+", delete=False) as tmpfile:
        json.dump(data, tmpfile)
        tmpfile.seek(0)
        yield tmpfile.name


@pytest.fixture
def project_model(project_file):
    return ProjectModel(filepath=project_file)


def test_get_project_with_id(project_model):
    project = project_model.getProject(id=1)
    assert project["id"] == 1
    assert project["name"] == "Project 1"
    assert project["description"] == "Description 1"


def test_get_project_without_id(project_model):
    projects = project_model.getProject()
    assert len(projects) == 2


def test_get_project_with_invalid_id(project_model):
    project = project_model.getProject(id=999)
    assert project is None
