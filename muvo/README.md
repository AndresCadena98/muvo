# 🎬 Muvo

Una aplicación moderna de películas construida con Flutter, siguiendo las mejores prácticas de desarrollo y una arquitectura limpia.

## 🚀 Características

- 🎯 Clean Architecture
- 🎨 UI/UX moderna y atractiva
- 🔄 Estado manejado con BLoC
- 🌐 Integración con TMDB API
- 💾 Caché local con Hive
- 🔍 Búsqueda de películas
- 📱 Diseño responsive
- 🌙 Tema oscuro por defecto

## 🏗 Arquitectura

El proyecto sigue Clean Architecture con una estructura clara y modular:

```
lib/
├── core/
│   ├── config/         # Configuración global
│   ├── error/          # Manejo de errores
│   └── network/        # Configuración de red
├── features/
│   └── movies/
│       ├── data/       # Implementación de repositorios
│       ├── domain/     # Entidades y casos de uso
│       └── presentation/
│           ├── bloc/   # Estado y lógica
│           ├── pages/  # Pantallas
│           └── widgets/# Componentes UI
└── main.dart
```

## 🛠 Tecnologías

- **Flutter**: Framework UI
- **BLoC**: Manejo de estado
- **Dio**: Cliente HTTP
- **Retrofit**: Generación de API client
- **Hive**: Base de datos local
- **GetIt**: Inyección de dependencias
- **Flutter Dotenv**: Variables de entorno
- **Cached Network Image**: Caché de imágenes
- **Shimmer**: Efectos de carga

## 📱 Características Implementadas

- [x] Configuración inicial del proyecto
- [x] Arquitectura base
- [x] Tema y estilos
- [x] Integración con TMDB API
- [ ] Lista de películas populares
- [ ] Búsqueda de películas
- [ ] Detalles de película
- [ ] Caché local
- [ ] Filtros y categorías
- [ ] Favoritos

## 🚀 Próximas Características

- [ ] Autenticación de usuarios
- [ ] Listas personalizadas
- [ ] Recomendaciones
- [ ] Modo offline
- [ ] Notificaciones
- [ ] Compartir películas

## 🛠 Requisitos

- Flutter SDK >= 3.5.0
- Dart SDK >= 3.0.0
- API Key de TMDB

## ⚙️ Configuración

1. Clona el repositorio
2. Crea un archivo `.env` en la raíz del proyecto
3. Agrega tu API key de TMDB:
   ```
   TMDB_API_KEY=tu_api_key_aquí
   ```
4. Instala las dependencias:
   ```bash
   flutter pub get
   ```
5. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

## 📝 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.

## 👥 Contribución

Las contribuciones son bienvenidas. Por favor, lee [CONTRIBUTING.md](CONTRIBUTING.md) para detalles sobre nuestro código de conducta y el proceso para enviarnos pull requests.

## 📧 Contacto

Andres Cadena - [@AndresCadena](https://github.com/AndresCadena)

Link del proyecto: [https://github.com/AndresCadena/muvo](https://github.com/AndresCadena/muvo)
