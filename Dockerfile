#https://pierreprinetti.com/blog/2018-the-go-1.11-web-service-dockerfile/
FROM golang as builder

# Create the user and group files that will be used in the running container to
# run the process as an unprivileged user.
RUN mkdir /user && \
    echo 'nobody:x:65534:65534:nobody:/:' > /user/passwd && \
    echo 'nobody:x:65534:' > /user/group



WORKDIR /Users/christopherlam/git/development/gomodules/docker

COPY go.mod .

COPY go.sum .

RUN go mod download

COPY . .
# Build the executable to `/app`. Mark the build as statically linked.
#RUN CGO_ENABLED=0 go build -a \
#    #-ldflags '-extldflags "-static"' \
#    -installsuffix 'static' \
#    #-installsuffix  \
#    -o /app .

RUN CGO_ENABLED=0 go build \
    -ldflags="-w -s" \
    -o /app .

# Final stage: the running container.
FROM scratch AS final

# Import the user and group files from the first stage.
COPY --from=builder /user/group /user/passwd /etc/


# Import the compiled executable from the first stage.
COPY --from=builder /app /app

EXPOSE 8000


# Perform any further action as an unprivileged user.
USER nobody:nobody

# Run the compiled binary.
ENTRYPOINT ["/app"]
