#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/sdk:6.0-focal AS build
WORKDIR /src
COPY . .
RUN dotnet restore "./JenkinsBuildTest/JenkinsBuildTest.csproj" --disable-parallel
RUN dotnet publish "./JenkinsBuildTest/JenkinsBuildTest.csproj" -c Release -o /app --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:6.0-focal
WORKDIR /app
COPY --from=build /app ./

ENV ASPNETCORE_URLS=http://+:5000

EXPOSE 5000

ENTRYPOINT ["dotnet", "JenkinsBuildTest.dll"]
