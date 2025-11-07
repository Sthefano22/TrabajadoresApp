# Etapa 1: build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiar archivos de proyecto y restaurar dependencias
COPY ["TrabajadoresApp.csproj", "./"]
RUN dotnet restore "./TrabajadoresApp.csproj"

# Copiar todo y publicar
COPY . .
RUN dotnet publish "TrabajadoresApp.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Etapa 2: runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

# Establecer la URL para que Kestrel escuche en el puerto 8080
ENV ASPNETCORE_URLS=http://+:8080

COPY --from=build /app/publish ./

EXPOSE 8080

ENTRYPOINT ["dotnet", "TrabajadoresApp.dll"]
