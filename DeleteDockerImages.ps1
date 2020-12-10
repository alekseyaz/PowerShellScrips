$NameDockerContainers = "laradock"
docker rm -f $(docker ps -a -q --filter name=$NameDockerContainers)
# docker rm -f $(docker ps -a -q)
# docker-compose down

$ImagesFilter = 'reference=eshop/*'
docker rmi $(docker images -a -q --filter=$ImagesFilter)
# docker rmi $(docker images -a -q)