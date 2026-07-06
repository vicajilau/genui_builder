# Build from the project root with:
# docker build -f genui_server/Dockerfile .

# Build stage
FROM dart:3.10.3 AS build

# Create a minimal workspace that preserves locked server dependency versions.
WORKDIR /app
COPY pubspec.lock .
COPY genui_server genui_server
RUN printf '%s\n' \
  'name: _' \
  'environment:' \
  '  sdk: ^3.10.3' \
  'workspace:' \
  '  - genui_server' \
  > pubspec.yaml
RUN dart pub get

# Compile the server executable.
WORKDIR /app/genui_server
RUN dart build cli --target bin/main.dart --output build
RUN mv build/bundle/bin/main build/bundle/bin/server

# Add a fallback for the copy of possibly missing directories.
RUN mkdir -p config web migrations

# Final stage
FROM alpine:latest
WORKDIR /app

# Environment variables
ENV runmode=production
ENV serverid=default
ENV logging=normal
ENV role=monolith

# Copy runtime dependencies
COPY --from=build /runtime/ /

# Copy compiled server executable and native libraries
COPY --from=build /app/genui_server/build/bundle/ ./

# Copy configuration files and resources
COPY --from=build /app/genui_server/config/ config/
COPY --from=build /app/genui_server/web/ web/
COPY --from=build /app/genui_server/migrations/ migrations/

# This file is required to enable the endpoint log filter in Insights.
COPY --from=build /app/genui_server/lib/src/generated/protocol.yaml lib/src/generated/protocol.yaml

# Expose ports
EXPOSE 8080
EXPOSE 8081
EXPOSE 8082

# Define the entrypoint command
ENTRYPOINT ./bin/server --mode=$runmode --server-id=$serverid --logging=$logging --role=$role
