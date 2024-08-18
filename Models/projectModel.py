import json


class ProjectModel:
    """A class representing a project model.
    Attributes:
        data (list): A list containing project data.
    Methods:
        __init__(self, filepath: str) -> None: Initializes the ProjectModel object
        by loading project data from a file.

        getProject(self, id=None): Retrieves a project based on its ID.
    """

    def __init__(self, filepath: str) -> None:
        with open(filepath) as file:
            self.data = json.load(file)

    def getProject(self, id=None):
        """Retrieves a project based on its ID.
        Args:
            id (int, optional): The ID of the project to retrieve.
            If not provided, returns all projects.
        Returns:
            dict or list: The project with the specified ID if found,
            or all projects if ID is not provided.
        """
        if isinstance(id, int):
            for project in self.data:
                if project["id"] == id:
                    return project
        else:
            return self.data
