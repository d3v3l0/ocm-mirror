# See https://aka.ms/containerfastmode to understand how Visual Studio 
# uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80


FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["API/OCM.Net/OCM.API.Worker/OCM.API.Worker.csproj", "API/OCM.Net/OCM.API.Worker/"]
RUN dotnet restore "API/OCM.Net/OCM.API.Worker/OCM.API.Worker.csproj"
COPY . .
WORKDIR "/src/API/OCM.Net/OCM.API.Worker"
RUN dotnet build "OCM.API.Worker.csproj" -c Release -o /app/build


FROM build AS publish
RUN dotnet publish "OCM.API.Worker.csproj" -c Release -o /app/publish


FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
RUN apt-get update && apt-get install -y \
    moreutils \
    && rm -rf /var/lib/apt/lists/*

# TODO: remove
RUN echo '#!/usr/bin/env bash\n\
\n\
set -Eeuo pipefail\n\
\n\
exec dotnet OCM.API.Worker.dll | ts "[%Y-%m-%dT%H:%M:%.SZ]" \n\
'\
    >> /app/start-worker.sh \
    && chmod +x /app/start-worker.sh


ENTRYPOINT exec /app/start-worker.sh
