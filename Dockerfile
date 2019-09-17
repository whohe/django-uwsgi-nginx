FROM alpine:latest
MAINTAINER Dockerfiles

RUN apk add python3 \
	python3-dev \
	py3-setuptools \
	py3-pip \
	nginx \
	sqlite \
	supervisor \
	gcc \
	libc-dev \
	linux-headers

RUN pip3 install uwsgi
RUN pip3 install -U pip setuptools

RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY nginx-app.conf /etc/nginx/conf.d/default.conf
RUN mkdir -p /run/nginx
COPY supervisor-app.conf /tmp/.
RUN cat /tmp/supervisor-app.conf >> /etc/supervisord.conf

COPY app/requirements.txt /home/docker/code/app/
RUN pip3 install -r /home/docker/code/app/requirements.txt

COPY . /home/docker/code/

RUN django-admin.py startproject website /home/docker/code/app/

EXPOSE 80
CMD ["supervisord", "-n"]
