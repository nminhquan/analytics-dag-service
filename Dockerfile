FROM python:3.8
RUN mkdir -p /opt/dagster/dagster_home /opt/dagster/app

RUN pip install \
    dagster \
    dagster-graphql \
    dagit \
    dagster-postgres \
    dagster-docker

# Copy your pipeline code and workspace to /opt/dagster/app
COPY repo.py workspace.yaml start.sh /opt/dagster/app/

ENV DAGSTER_HOME=/opt/dagster/dagster_home/ \
    DAGSTER_POSTGRES_USER=postgres_user \
    DAGSTER_POSTGRES_PASSWORD=postgres_password \
    DAGSTER_POSTGRES_DB=postgres_db

# Copy dagster instance YAML to $DAGSTER_HOME
COPY dagster.yaml /opt/dagster/dagster_home/

WORKDIR /opt/dagster/app

EXPOSE 8121

ENTRYPOINT ["sh", "./start.sh"]

# CMD ["dagster", "api", "grpc", "-h", "0.0.0.0", "-p", "4000", "-f", "repo.py"]

# CMD ["dagster-daemon", "run"]
