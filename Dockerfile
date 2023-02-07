#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/sdk:6.0-focal AS build
WORKDIR /src
COPY . .
RUN dotnet restore "./\JenkinsBuildTest/JenkinsBuildTest.csproj" --disable-parallel
RUN dotnet publish "./\JenkinsBuildTest/JenkinsBuildTest.csproj" -c Release -o /app --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:6.0-focal
WORKDIR /app
COPY --from=build /app ./

ENV ASPNETCORE_URLS=http://+:5000

EXPOSE 5000

ENTRYPOINT ["dotnet", "JenkinsBuildTest.dll"]
#FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
#WORKDIR /app
#EXPOSE 5000
#
#FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
#WORKDIR /src
#COPY ["ProductAPI/ProductAPI.csproj", "ProductAPI/"]
#RUN dotnet restore "ProductAPI/ProductAPI.csproj"
#COPY . .
#WORKDIR "/src/ProductAPI"
#RUN dotnet build "ProductAPI.csproj" -c Release -o /app/build
#
#FROM build AS publish
#RUN dotnet publish "ProductAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false
#
#FROM base AS final
#WORKDIR /app
#COPY --from=publish /app/publish .
#ENTRYPOINT ["dotnet", "ProductAPI.dll"]