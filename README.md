# devsecops_docker

## create image for all python security modules 
docker build -t digupats/security_scan_python -f Dockerfile .

Push it to dockerhub
docker push digupats/security_scan_python:latest
