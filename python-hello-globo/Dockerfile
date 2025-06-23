FROM python:3.13.5-alpine3.22

WORKDIR /app

COPY . .

RUN apk --no-cache add ca-certificates tzdata

ENV TZ=America/Sao_Paulo

RUN pip install -r requirements.txt

CMD ["python3", "main.py"]