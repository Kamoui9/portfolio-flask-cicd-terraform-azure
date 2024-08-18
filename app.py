from flask import Flask, redirect, render_template
from Models.projectModel import ProjectModel

projectModel = ProjectModel("db/projects.json")

app = Flask(__name__)


@app.route("/")
def index():
    return redirect("/about")


@app.route("/favicon.ico")
def favicon():
    return "", 200


@app.route("/about")
def about():
    return render_template("about.html")


@app.route("/projects")
def projects():
    projects = projectModel.getProject()
    return render_template("projects.html", projects=projects)


@app.route("/photos")
def photos():
    return render_template("photos.html")


@app.route("/<path:invalid_path>")
def error(invalid_path):
    return "Error: Page not found", 404


# if __name__ == "__main__":
#     app.run(debug=True)
