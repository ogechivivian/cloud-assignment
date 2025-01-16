
# Build stage using .NET Core 2.2 SDK
FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /app
COPY . ./
RUN dotnet restore
RUN dotnet publish -c Release -o out

# Runtime stage
FROM debian:11-slim
WORKDIR /app

# Install .NET Core 2.2 runtime dependencies
RUN apt-get update && apt-get install -y libssl1.0.0 libicu66 libunwind8 && rm -rf /var/lib/apt/lists/*

# Copy the .NET Core 2.2 runtime
COPY --from=build /usr/share/dotnet /usr/share/dotnet
ENV DOTNET_ROOT=/usr/share/dotnet
ENV PATH=$PATH:/usr/share/dotnet

# Copy the published output
COPY --from=build /app/out .

# Set the entry point
ENTRYPOINT ["dotnet", "aspnet-core-dotnet-core.dll"]

#
##Build stage
##FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
#FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim  AS build
#WORKDIR /app
#
## Copying files to the build container
##COPY ../cloud-assignment ./
#COPY . ./
#
#
## Restore nuget packages
#RUN dotnet restore
#
## Publishing the app in Release mode to the /out folder
#RUN dotnet publish -c Release -o out
#
##  Runtime stage
#FROM mcr.microsoft.com/dotnet/aspnet:2.2 AS runtime
#WORKDIR /app
#
## Copying only the published output from the build stage
#COPY --from=build /app/out .
#
## Start the application by default
#ENTRYPOINT [ "dotnet", "aspnet-core-dotnet-core.dll" ]
