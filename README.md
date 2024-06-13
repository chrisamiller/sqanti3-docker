# README

A docker image for running [SQANTI3](https://github.com/ConesaLab/SQANTI3)

forked from joelnitta/sqanti3-docker 

## Notes

To build on mac silicon use:
`docker build --platform=linux/amd64 .`
or the conda install will be unhappy

## Usage on the RIS cluster:

LSF_DOCKER_PRESERVE_ENVIRONMENT=false bsub . . . -a "docker(chrisamiller/sqanti3:v5.1.2)" /bin/bash -c "source activate SQANTI3.env && /app/SQANTI3-5.1.2/sqanti3_qc.py . . . "

