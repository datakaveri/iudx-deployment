ARG es_version
FROM docker.elastic.co/elasticsearch/elasticsearch:${es_version}

RUN  bin/elasticsearch-plugin install --batch repository-s3

