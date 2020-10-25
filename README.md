# dockerizame.sh
sh script for create a minimun docker application from scratch

*Example*
```
from alpine AS builder

RUN apk add --no-cache build-base
COPY main.c /
COPY dockerizame.sh /

RUN gcc main.c -o main
RUN sh -x /dockerizame.sh -v /main -d /docke

FROM scratch

COPY --from=builder /main /main
COPY --from=builder /docke/ /

CMD ["/main"]
```
