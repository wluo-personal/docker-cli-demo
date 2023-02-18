# docker-cli-demo
# Setup Python Project
`conda create --name pdocker python=3.11 --no-default-packages`

`conda activate pdocker`

`pip install poetry`

Under project path (make sure 'poetry.lock' is deleted )

`poetry install`


# Build Docker File
- sudo docker build --build-arg TOKEN=${GITHUB_TOKEN} -t <image_name> .
- sudo docker build --build-arg TOKEN='' -t toneymall/docker_cli_demo .


# RUN Docker file
`sudo docker run -it --rm toneymall/docker_cli_demo  demo2 --val "This is test2"`