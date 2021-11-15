[![CI](https://github.com/makerling/packaging-ext/actions/workflows/deb-rpm.yml/badge.svg)](https://github.com/makerling/packaging-ext/actions/workflows/deb-rpm.yml)
## Table of contents
* [General info](#general-info)
* [Technologies](#technologies)
* [Setup](#setup)

## General info
This project uses Github Actions to create a .deb and .rpm artifact of the postgresql pg_jobmon extension
	
## Technologies
Project is created with:
* bash: 
* ruby (fpm library): 2.33
* Ubuntu runner (Github Actions): 20.04
	
## Setup
To run this project, clone it locally and run 
```
$ bash start_pipeline.sh
```
The resulting artifacts can be accessed in the 'artifacts' section of each pipeline run

## Roadmap
Implement additional step of installing the packages in a docker container with verification steps to test funtionality of packages.  
