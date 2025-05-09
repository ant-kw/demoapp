FROM alpine:latest as builder

RUN apk add python3 py3-pip tzdata

COPY requirements.txt requirements.txt

RUN python3 -m venv .venv
RUN .venv/bin/pip install --upgrade pip
RUN .venv/bin/pip install -r /requirements.txt


FROM alpine:latest

RUN apk add python3 py3-pip tzdata

COPY --from=builder .venv .venv

ADD frontend frontend

ENV PATH="$PATH:/.venv/bin"

EXPOSE 8080

WORKDIR /frontend

ENTRYPOINT ["gunicorn"]
CMD ["-b", "0.0.0.0:8080", "frontend.wsgi"]


