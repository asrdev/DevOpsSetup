# Create and then push the local docker images to docker hub.

1. Signin/Signup: https://hub.docker.com/

2. Create a repository or organization. ex: apacherepo

3. Create a docker file for apache installation.
    sudo vi DockerFileApache
    
          #Docker will donwload the the image ubuntu with the tag 12.04 and create a container with ubuntu OS with the version of 12.04
          FROM ubuntu:12.04

          #Install dependencies
          RUN apt-get update -y
          RUN apt-get install -y apache2

          #Install apache and write hello world message
          RUN echo "Hello World!" > /var/www/index.html

          #Configure apache
          RUN a2enmod rewrite
          RUN chown -R www-data:www-data /var/www
          ENV APACHE_RUN_USER www-data
          ENV APACHE_RUN_GROUP www-data
          ENV APACHE_LOG_DIR /var/log/apache2

          #apache available on 8080 port.
          EXPOSE 80

          CMD ["/usr/sbin/apache2", "-D",  "FOREGROUND"]
    
4. Build the image: docker build -t imageName:tagVersion -f ./DockerFilePath .

        ex: docker build -t apache:1.0 -f ./DockerFileApache .
        sudo docker images
   
5. Run the command to login to docker hub registry: docker login

        ex: sudo docker login

6. Tag the local image with docker repo: docker tag imageID dokcerhubID/repoName:1.0

        ex: sudo docker tag 3bdf41be5265 venkatasykam/apacherepo:1.0

7. Push the image to dokcer hub: docker push dokcerhubID/repoName:1.0

        ex: sudo docker push venkatasykam/apacherepo:1.0
        
8. Pull the image anywhere: sudo docker pull <dokcerhubID>/repoName:1.0
    
        ex: ex: sudo docker pull venkatasykam/apacherepo:1.0

9. Run the image: sudo docker run -p 80:80 dokcerhubID/repoName:1.0

        ex: sudo docker run -p 80:80 venkatasykam/apacherepo:1.0
