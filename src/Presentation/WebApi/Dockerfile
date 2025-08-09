# --- Runtime Image ---
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
EXPOSE 8080

# --- Build & Publish Image ---
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Önce csproj kopyala ve restore yap
COPY WebApi.csproj .
RUN dotnet restore WebApi.csproj

# Sonra tüm kaynak kodu kopyala ve publish et
COPY . .
RUN dotnet publish WebApi.csproj -c Release -o /out /p:UseAppHost=false

# --- Final Image ---
FROM base AS final
WORKDIR /app
COPY --from=build /out .

ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production

ENTRYPOINT ["dotnet", "WebApi.dll"]
