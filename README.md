# jugs

Jupyter Notebook with Google Compute Storage access.


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

**Linux**`
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

Note:
  - if folders are missing, use the `--implicit-dirs` option (slow!)


### Start Jupyter Notebook

```bash
~/miniconda/envs/jugs/bin/jupyter notebook --allow-root --no-browser --ip=$(hostname -i)
```

Notes:

* use `localhost` in place of the IP address in the URL
* use this option to avoid using the token: --NotebookApp.token=''


You can now create Jupyter notebooks which have access to a Google bucket!


### Stop and delete container

docker stop jugs
docker rm -vf jugs

### Delete image

docker rmi -f jugs
