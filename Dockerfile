FROM python:3-onbuild

# onbuild does this:
#RUN mkdir -p /usr/src/app
#WORKDIR /usr/src/app
#
#ONBUILD COPY requirements.txt /usr/src/app/
#ONBUILD RUN pip install --no-cache-dir -r requirements.txt
#
#ONBUILD COPY . /usr/src/app

VOLUME /usr/src/app

RUN mkdir /etc/luigi
COPY client.cfg /etc/luigi/client.cfg
# override the stock config by placing client.cfg in /usr/src/app/.

EXPOSE 8082
WORKDIR /usr/src/app/

CMD /usr/local/bin/luigid
