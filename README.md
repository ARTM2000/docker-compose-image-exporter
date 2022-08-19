# docker-compose image exporter

This project created to store or save images that will use with docker-compose to run a project.

## Instruction
Copy the `exporter.sh` file at same level of your `docker-compose.yml` or `docker-compose.yaml` and run command below (replace your custom export file name with `my-file-name`):
```bash
$ bash exporter.sh my-file-name
```
e.g:
```bash
$ bash exporter.sh images.tar.gz
```

The output is a file containing all images which will use in targeted `docker-compose.yml` or `docker-compose.yaml`.

Happy Coding 😉
