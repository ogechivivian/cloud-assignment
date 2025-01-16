
#Build stage
#FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim  AS build
WORKDIR /app

# Copying files to the build container
#COPY ../cloud-assignment ./
COPY . ./


# Restore nuget packages
RUN dotnet restore

# Publishing the app in Release mode to the /out folder
RUN dotnet publish -c Release -o out

#  Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:2.2 AS runtime
WORKDIR /app

# Copying only the published output from the build stage
COPY --from=build /app/out .

# Start the application by default
ENTRYPOINT [ "dotnet", "aspnet-core-dotnet-core.dll" ]
