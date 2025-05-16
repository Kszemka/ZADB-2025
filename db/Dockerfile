FROM postgres:15

ENV POSTGRES_USER=admin
ENV POSTGRES_PASSWORD=admin
ENV POSTGRES_DB=db

COPY init.sql/ /docker-entrypoint-initdb.d/
