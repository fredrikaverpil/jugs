# jugs :sake:

This is a Docker container which runs `gcsfuse` and `jupyter-notebook`, which allows to make notebooks on live Google bucket data sets.

- See the [`Dockerfile`](Dockerfile) for details on Python setup
- Requires JSON key credentials from Google for bucket access (uses `gcloud` for auth)


## Instructions

### Clone repo

```bash
git clone https://github.com/fredrikaverpil/jugs.git
```

### Google credentials

To gain access to a bucket, download a Google JSON credentials file from your GCE console and place it in the repository root folder as `key.json`.


### Build container

```bash
docker build -t fredrikaverpil/jugs .
```

### Run container

**Linux**
```bash
docker run --rm --detach --privileged --name="jugs" --hostname jugs -p 8888:8888 --volume $(pwd):/jugs fredrikaverpil/jugs
```

**Windows (CMD.exe)**
```bash
docker run --rm --detach --privileged --name="jugs" --hostname jugs -p 8888:8888 --volume %CD%:/jugs fredrikaverpil/jugs
```

**Windows (Powershell)**
```bash
docker run --rm --detach --privileged --name="jugs" --hostname jugs -p 8888:8888 --volume ${PWD}:/jugs fredrikaverpil/jugs
```

### Enter container

```bash
docker exec -ti jugs bash
```

### Mount Google Storage bucket

```bash
mkdir -p /bucket
gcsfuse -o ro --key-file=/jugs/key.json my-bucket /bucket  # read only access
```

If folders are missing, use the `--implicit-dirs` option (slow!), read more on that [here](https://github.com/GoogleCloudPlatform/gcsfuse/blob/master/docs/semantics.md#implicit-directories).


### Start Jupyter Notebook

```bash
~/miniconda/envs/jugs/bin/jupyter notebook --allow-root --no-browser --ip=$(hostname -i)
```

Notes:

- Access Jupyter: `http://localhost:8888`
- Use this option to avoid using the token: `--NotebookApp.token=''`

You can now create Jupyter notebooks which have live access to a Google bucket. Save the notebooks in `/jugs` so that you can access them later...


### Stop and delete container

```bash
docker stop jugs
docker rm -vf jugs
```

### Delete image

```bash
docker rmi -f jugs
```
