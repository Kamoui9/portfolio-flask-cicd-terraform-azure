# WARNING : tests wrote by Copilot
from flask_testing import TestCase
from app import app


class TestFlaskApp(TestCase):
    def create_app(self):
        app.config["TESTING"] = True
        return app

    def test_index_redirects(self):
        response = self.client.get("/")
        self.assertTrue(
            response.location.endswith("/about"),
            "The redirect should end with '/about'",
        )

    def test_favicon_page(self):
        response = self.client.get("/favicon.ico")
        self.assertEqual(response.status_code, 200)

    def test_about_page(self):
        response = self.client.get("/about")
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed("about.html")

    def test_projects_page(self):
        response = self.client.get("/projects")
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed("projects.html")

    def test_photos_page(self):
        response = self.client.get("/photos")
        self.assertEqual(response.status_code, 200)
        self.assertTemplateUsed("photos.html")

    def test_404_page(self):
        response = self.client.get("/a_page_that_does_not_exist")
        self.assertEqual(response.status_code, 404)
