FROM golang:1.23.1-alpine AS build

WORKDIR /app

RUN apk add --no-cache tzdata

COPY . .

RUN go mod download &&\
    CGO_ENABLED=0 GOOS=linux go build -o golang-app .

FROM scratch

COPY --from=build /app/golang-app .
COPY --from=build /usr/share/zoneinfo/ /usr/share/zoneinfo/
COPY --from=build /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
ENV TZ=America/Sao_Paulo

CMD ["./golang-app"]
