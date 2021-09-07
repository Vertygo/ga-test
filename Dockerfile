#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["ga-test/ga-test.csproj", "ga-test/"]
RUN dotnet restore "ga-test/ga-test.csproj"
COPY . .
WORKDIR "/src/ga-test"
RUN dotnet build "ga-test.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "ga-test.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "ga-test.dll"]