# GCR plugin
![workflow status](https://github.com/UPN-TW/gcr/actions/workflows/gcr.yml/badge.svg)

An action to build docker image and push to Google Cloud Registry.

## Usage
```yaml
jobs:
  job_id:
    steps:
      - uses: actions/checkout@v3
      - uses: UPN-TW/gcr@v1.0
        with:
          gcr_auth_key: ${{ secrets.GCR_AUTH_KEY }}
          registry: gcr.io
          project_id: project_id
          image: backend
          tags: latest,v1
          dockerfile: ./docker/Dockerfile.prod
          context: ./docker
```

## Inputs
- `gcr_auth_key`: The service account key of Google Cloud project that composed of JSON can be encoded in base64 or in plain text.
- `registry`: The registry where the image should be pushed.
- `project_id`: Project ID of the Google Cloud project.
- `image`: The image name.
- `tags`: (Optional) A list of image tags separated by commas (e.g. v2.1,v2,latest).<br>Default: `latest`.
- `dockerfile`: (Optional) The image building Dockerfile, if the context is not the root of the repository, Dockerfile from the context folder will be used.<br>Default: `./Dockerfile`.
- `context`: (Optional) The docker build context.<br>Default: `.`
- `build-args`: (Optional) Pass a list of environment variables as build-args for docker-build, separated by commas. ie: `HOST=db.default.svc.cluster.local:5432,USERNAME=db_user`.
