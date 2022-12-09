FROM eclipse-temurin:18-alpine

RUN apk update && apk upgrade && apk add bash curl jq vim

ENV KAFKA_URL=https://dlcdn.apache.org/kafka/3.3.1/kafka_2.13-3.3.1.tgz
ENV KAFKA_DOWNLOAD=/download/kafka.tgz
ENV KAFKA_WORKDIR=/cli/kafka
ENV PATH=${KAFKA_WORKDIR}/bin:${PATH}:/scripts
ENV AIVEN_CONF=/cli/kafka/config/aiven.conf

RUN curl ${KAFKA_URL} --create-dirs -o ${KAFKA_DOWNLOAD}
RUN mkdir -p ${KAFKA_WORKDIR}
RUN tar -xvzpf ${KAFKA_DOWNLOAD} --strip-components=1 -C ${KAFKA_WORKDIR} && rm ${KAFKA_DOWNLOAD}

WORKDIR ${KAFKA_WORKDIR}

COPY entrypoint.sh /cli/
COPY scripts /scripts

RUN touch ${AIVEN_CONF}
RUN chmod 777 ${AIVEN_CONF}

CMD ["/cli/entrypoint.sh"]
