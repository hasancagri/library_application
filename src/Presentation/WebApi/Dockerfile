FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# csproj'u kökten doğru yolla kopyala
COPY src/Presentation/WebApi/WebApi.csproj .
RUN dotnet restore WebApi.csproj

# kaynakları kökten doğru yolla kopyala
COPY src/Presentation/WebApi/ .
RUN dotnet publish WebApi.csproj -c Release -o /Output --no-restore /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /App
COPY --from=build /Output .

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080
ENTRYPOINT ["dotnet", "WebApi.dll"]
