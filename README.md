# 🎓 Academia Platform

**Plataforma de gestión educativa para clases de regularización en línea.**

![Estado](https://img.shields.io/badge/Estado-En%20desarrollo-blue)
![Node.js](https://img.shields.io/badge/Node.js-24.x-green)
![Express](https://img.shields.io/badge/Express-5.x-black)
![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-4.x-06B6D4)

## 📖 Descripción del proyecto

Academia Platform es una plataforma web de gestión educativa orientada principalmente a estudiantes de secundaria que requieren acompañamiento académico y clases de regularización en línea.

Su propósito es centralizar la administración de clases, materiales, actividades, evaluaciones y seguimiento del aprendizaje, ofreciendo una experiencia intuitiva para estudiantes, profesores, padres de familia y administradores.

Las clases en vivo se realizarán mediante Google Meet o Microsoft Teams.

> **Estado actual:** configuración inicial del proyecto y primera vista renderizada mediante SSR.

## 🎯 Objetivo general

Desarrollar una plataforma educativa web segura, accesible, escalable y responsiva que facilite el proceso de regularización académica, la entrega de actividades y el seguimiento del progreso estudiantil.

## 👥 Roles del sistema

| Rol | Funcionalidades previstas |
|---|---|
| 🎒 Estudiante | Consultar clases, materiales, tareas y progreso |
| 👨‍🏫 Profesor | Programar clases, asignar actividades y evaluar |
| 👨‍👩‍👧 Tutor | Consultar asistencia, desempeño y observaciones |
| 🛡️ Administrador | Gestionar usuarios, materias, grupos y sesiones |

## 🧩 Módulos previstos

- 🔐 Autenticación y gestión de usuarios
- 📊 Paneles personalizados según el rol
- 📚 Gestión de materias y contenidos
- 🎥 Clases en vivo mediante Meet o Teams
- 📝 Asignación y entrega de tareas
- 📈 Seguimiento del progreso académico
- 📅 Calendario de sesiones
- 🔔 Notificaciones y recordatorios
- 📄 Reportes académicos
- 🛡️ Administración y seguridad

Estas funcionalidades se implementarán progresivamente.

## 🛠️ Tecnologías

| Tecnología | Uso |
|---|---|
| Node.js | Entorno de ejecución |
| Express.js | Servidor web y rutas |
| Handlebars | Renderizado del lado del servidor (SSR) |
| Tailwind CSS | Diseño responsivo |
| JavaScript | Lógica de aplicación |
| Morgan | Registro de solicitudes HTTP |
| Helmet | Cabeceras de seguridad |
| dotenv | Variables de entorno |
| Nodemon | Reinicio automático en desarrollo |
| ESLint | Análisis estático |
| Prettier | Formato del código |
| Git y GitHub | Control de versiones |

### Tecnologías planificadas

- PostgreSQL para persistencia de datos
- Docker y Docker Compose para contenedores
- Integraciones con Google Meet y Microsoft Teams

## 📂 Estructura del proyecto

```text
academia-platform/
├── src/
│   ├── config/
│   ├── controllers/
│   ├── middlewares/
│   ├── routes/
│   ├── services/
│   ├── styles/
│   ├── views/
│   │   ├── layouts/
│   │   └── partials/
│   └── app.js
├── public/
│   ├── css/
│   ├── js/
│   └── images/
├── server.js
├── .env.example
├── package.json
└── README.md
```

## 🚀 Instalación local

### Requisitos

- Node.js 24.x
- npm
- Git

### 1. Clonar el repositorio

```bash
git clone https://github.com/america23-cloud/academia-platform.git
cd academia-platform
```

### 2. Instalar dependencias

```bash
npm ci
```

### 3. Configurar variables de entorno

Crear un archivo `.env` tomando como referencia `.env.example`.

```env
NODE_ENV=development
PORT=3000
```

### 4. Compilar los estilos

```bash
npm run build:css
```

### 5. Iniciar el servidor

```bash
npm run dev
```

Abrir en el navegador:

**http://localhost:3000**

> Los comandos anteriores funcionarán cuando la rama correspondiente contenga la configuración inicial. No es necesario instalar PostgreSQL o Docker para ejecutar esta primera versión.

## 🌿 Estrategia de ramas

| Rama | Propósito |
|---|---|
| `main` | Código estable |
| `develop` | Integración de funcionalidades |
| `feature/*` | Nuevas funcionalidades |
| `fix/*` | Correcciones |
| `docs/*` | Documentación |
| `refactor/*` | Mejoras internas del código |

### Flujo de trabajo

1. Actualizar la rama `develop`.
2. Crear una rama de trabajo a partir de `develop`.
3. Desarrollar y probar los cambios.
4. Realizar commits descriptivos.
5. Publicar la rama en GitHub.
6. Crear un Pull Request hacia `develop`.
7. Revisar y fusionar los cambios.

No se desarrollará directamente sobre `main`.

## 🏷️ Convención de commits

Formato:

```text
<emoji> <tipo>(alcance): descripción
```

### Diccionario de emojis

| Emoji | Tipo | Significado |
|---|---|---|
| ✨ | `feat` | Nueva funcionalidad |
| 🐛 | `fix` | Corrección de errores |
| 📝 | `docs` | Documentación |
| 💄 | `style` | Estilos o formato |
| ♻️ | `refactor` | Refactorización |
| ⚡ | `perf` | Rendimiento |
| ✅ | `test` | Pruebas |
| 🔧 | `chore` | Mantenimiento |
| 📦 | `build` | Dependencias y compilación |
| 👷 | `ci` | Integración continua |
| 🔒 | `security` | Seguridad |
| 🐳 | `docker` | Contenedores |
| 🗃️ | `db` | Base de datos |
| 🚀 | `deploy` | Despliegue |
| ⏪ | `revert` | Reversión de cambios |

### Ejemplos

```bash
git commit -m "✨ feat(auth): add login page"
git commit -m "🐛 fix(classes): correct session validation"
git commit -m "📝 docs: update installation guide"
git commit -m "💄 style(dashboard): improve responsive layout"
git commit -m "🐳 docker: add development containers"
git commit -m "🔒 security(auth): improve access controls"
```

## 🔒 Seguridad y privacidad

La plataforma está orientada a menores de edad, por lo que se contemplan medidas de protección de datos personales desde el diseño:

- Acceso según roles y permisos
- Protección de contraseñas y sesiones
- Restricción de acceso a archivos académicos
- Protección de datos personales
- Consentimiento y participación de padres o tutores
- Validación de archivos y formularios
- Prevención de exposición de información sensible en logs

## 🗺️ Roadmap

- [x] Crear repositorio GitHub
- [x] Configurar ramas iniciales
- [x] Inicializar Node.js y Express
- [x] Configurar Handlebars y SSR
- [x] Integrar Tailwind CSS
- [x] Integrar Morgan y Helmet
- [x] Crear primera vista funcional
- [ ] Documentar y fusionar configuración inicial
- [ ] Configurar Docker
- [ ] Implementar base de datos
- [ ] Diseñar autenticación
- [ ] Crear paneles por rol
- [ ] Desarrollar módulo de clases
- [ ] Desarrollar módulo de tareas
- [ ] Implementar seguimiento académico
- [ ] Preparar pruebas y despliegue

## 👩‍💻 Equipo

Proyecto desarrollado por un equipo universitario de Tecnologías de la Información y Comunicación.

**Responsabilidades iniciales:**

- Ame — Desarrollo de la plataforma educativa
- Josué — Desarrollo del sitio web informativo
- Dana — Redes sociales y presencia digital

## 📄 Licencia

El archivo `package.json` contiene actualmente la licencia ISC; la licencia definitiva del emprendimiento está pendiente de acordarse entre los integrantes.

---

**Academia Platform — Aprender, practicar y avanzar.** 🎓
