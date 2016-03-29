FROM python:3-slim
# slim=debian-based

# onbuild does this:
#RUN mkdir -p /usr/src/app
#WORKDIR /usr/src/app
#
#ONBUILD COPY requirements.txt /usr/src/app/
#ONBUILD RUN pip install --no-cache-dir -r requirements.txt
#
#ONBUILD COPY . /usr/src/app

RUN apt-get update && apt-get install -y libpq-dev gcc
# need gcc to compile psycopg2
RUN pip3 install psycopg2~=2.6 awscli
RUN apt-get autoremove -y gcc

# partial alpine dependencies
# RUN apk update && apk add postgresql-dev
# postgres for python psycopg2 support

#VOLUME /usr/src/app
WORKDIR /usr/src/app
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r requirements.txt
#COPY . /usr/src/app

RUN mkdir /etc/luigi
COPY client.cfg /etc/luigi/client.cfg
# override the stock config by placing client.cfg in /usr/src/app/.

ENV luigi_config_s3_path="TODO"
CMD echo "env: $luigi_config_s3_path"
CMD if ["$luigi_config_s3_path" != "TODO" ]; then echo "overriding from s3"; aws --region=us-east-1 s3 cp ${luigi_config_s3_path} /etc/luigi/client.cfg; fi

EXPOSE 8082
WORKDIR /usr/src/app/

CMD /usr/local/bin/luigid
