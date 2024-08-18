# portfolio-flask-cicd-terraform-azure

> A small portfolio website built as a hands-on project to learn and master CI/CD, Infrastructure as Code (IaC), and cloud technologies.

This project serves as a comprehensive learning experience, allowing me to design, develop, and deploy a fully functional personal portfolio from start to finish.

![/about](/static/img/readme/abouttheme.png)
![/photos](/static/img/readme/photos.png)


## Project stack

* **Python - Flask (Web server)**
    * Gunicorn for the WSGI server (previously used uWSGI, but it conflicts with Microsoft Oryx and Gunicorn is easier to set up)
    * Poetry for dependencies and virtual environment management
    * Pytest and Flask-Testing for tests and test coverage
    * Black formatter for adhering to PEP requirements
* ~~NGINX as a reverse proxy~~ *(removed because Azure Linux Web App on Terraform doesn't support Docker Compose yet)*

* **GitHub Actions (CI/CD)**
* **Terraform (IaC)**
    * AzureRM provider for managing cloud infrastructure
    * GitHub provider for managing secrets and environment variables
    * Cloudflare provider for handling DNS records

* **Azure Linux Web App** *(previously used Azure AKS, but $120/month to run a static website is too expensive for me)*

> A global diagram is available in `global.vdsx`.

## Installation (developpement setup)
> You can view the live project at https://mateo.pannetier.dev. However, if you'd like to run it on your local machine for development purposes, follow the steps below:

### Prerequisites
Ensure that the following tools and dependencies are installed on your system:

- **Dev Container:** (Optional) Recommended for a consistent development environment.

or 

- **Python 3.11:** Ensure Python 3.11 is installed.
- **Azure CLI (azcli):** Required for managing Azure resources.
- **Terraform:** For Infrastructure as Code (IaC) setup.
- **Poetry:** (Optional) Dependency management and packaging in Python.

### Installation Steps

1. **Clone the Repository:**
```bash
git clone https://github.com/Kamoui9/portfolio-flask-cicd-terraform-azure
```

2. **Set Up the Development Environment:**
- If using a Dev Container, open the project in Visual Studio Code and use the provided dev container configuration. (more documentation [here](https://code.visualstudio.com/docs/devcontainers/containers))

- If not using a Dev Container, ensure the prerequisites tools are installed and configured locally.

3. **Install Dependencies:**
* Using **pip** in a venv:

```bash
python3 -m venv myenv      # Create a virtual environment named "myenv"
source myenv/bin/activate # Activate the virtual environment
pip install -r requirements.txt # Install dependencies
```

* Using **Poetry**:
```bash
poetry install # Install dependencies
portry shell # Activate the virtual environment
```

4. **Run the Application:**
```bash
gunicorn app:app
```

> If you're using a Dev Container in VS Code, you can open the bottom tab (Ctrl+J) and forward port 8000 using the Port tab.

Now, the app should be accessible at `localhost:8000`.

5. **Deploy the Application**
Connect to Azure :
```bash
az login
```

Deploy :
> **WARNING**: This command engages cost and should be launched if you are sure of what you are doing. I am not responsible for any loss that may occur. You should monitor your cost carefully.
```bash
terraform init
terraform apply -auto-approve
```

And then you need to push your code to the main branch or manually re-run the release workflow.

If you want to destroy your resources, you can use the following command:
```bash
terraform destroy -auto-approve
```


<!-- ## Release History

* 0.0.1
    * Initial work -->