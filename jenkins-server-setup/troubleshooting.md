# Troubleshooting Docker Permission Error

If you encounter an error like this:

```
ERROR: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Head "http://%2Fvar%2Frun%2Fdocker.sock/_ping": dial unix /var/run/docker.sock: connect: permission denied
```

Then change the socket file permission using the following command:

```sh
chmod 666 /var/run/docker.sock
```
```
