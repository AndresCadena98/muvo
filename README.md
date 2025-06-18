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
- [x] Arquitectura base (Clean Architecture)
- [x] Tema y estilos
- [x] Integración con TMDB API
- [x] Navegación principal con 4 secciones:
  - [x] Home (Películas populares)
  - [x] Explorar
  - [x] Favoritos
  - [x] Configuración
- [x] Gestión de películas:
  - [x] Lista de películas populares
  - [x] Lista de películas mejor valoradas
  - [x] Lista de películas próximas
  - [x] Búsqueda de películas
  - [x] Detalles de película
  - [x] Créditos de película
  - [x] Videos de película
  - [x] Reseñas de película
  - [x] Películas similares
  - [x] Recomendaciones
- [x] Filtros y categorías:
  - [x] Filtros por género
  - [x] Filtros por año
  - [x] Filtros por idioma
  - [x] Filtros por región
  - [x] Filtros por rango de fechas
- [x] UI/UX:
  - [x] Diseño responsive
  - [x] Tema oscuro por defecto
  - [x] Animaciones y transiciones
  - [x] Paginación infinita
  - [x] Búsqueda con debounce
  - [x] Tarjetas de películas con efectos
  - [x] Vista en grid y lista
  - [x] Swiper vertical de películas
  - [x] Indicadores de carga personalizados
  - [x] Placeholders para imágenes
- [x] Autenticación:
  - [x] Login/Registro con email
  - [x] Login con Google
  - [x] Gestión de sesión
- [x] Favoritos:
  - [x] UI implementada
  - [x] Integración con Firestore
  - [x] Gestión de favoritos por usuario
- [ ] Caché local
- [ ] Compartir películas (UI implementada, pendiente lógica)

## 🚀 Próximas Características

- [ ] Listas personalizadas
- [ ] Modo offline
- [ ] Notificaciones
- [ ] Estadísticas de usuario
- [ ] Recomendaciones personalizadas
- [ ] Integración con redes sociales

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
