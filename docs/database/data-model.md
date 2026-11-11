
# Academia Platform
## Modelo de datos — Versión 1.0

### 1. Objetivo

Diseñar una base de datos relacional para gestionar
una plataforma de regularización académica en línea.

La plataforma permitirá administrar usuarios,
materias, grupos, clases, inscripciones, tareas,
entregas, evaluaciones y pagos.

### 2. Motor de base de datos

- Sistema gestor: PostgreSQL 17
- Base de datos local: academia_db
- Backend: Node.js + Express
- Controlador: pg
- Entorno local: Docker Compose

### 3. Roles del sistema

**Administrador**
- Gestionar usuarios y permisos.
- Administrar materias y grupos.
- Supervisar inscripciones y pagos.

**Profesor**
- Consultar grupos asignados.
- Programar clases.
- Publicar tareas.
- Evaluar entregas.

**Alumno**
- Consultar materias y clases.
- Entregar actividades.
- Revisar calificaciones y progreso.

**Padre o tutor**
- Consultar información de alumnos vinculados.
- Revisar tareas, avances y calificaciones.

### 4. Entidades principales

| Entidad | Responsabilidad |
|---|---|
| users | Información general de usuarios |
| roles | Catálogo de roles |
| user_roles | Asignación de roles a usuarios |
| student_guardians | Relación alumno-tutor |
| subjects | Catálogo de materias |
| groups | Grupos académicos |
| enrollments | Inscripciones de alumnos |
| classes | Sesiones de clase |
| assignments | Tareas y actividades |
| submissions | Entregas de los alumnos |
| grades | Calificaciones y retroalimentación |
| payments | Registro de pagos |

### 5. Relaciones principales

- Un usuario puede tener uno o varios roles.
- Un tutor puede estar vinculado con varios alumnos.
- Un alumno puede tener varios tutores autorizados.
- Una materia puede ofrecerse en varios grupos.
- Un profesor puede impartir varios grupos.
- Un alumno puede inscribirse en varios grupos.
- Un grupo puede tener varias clases y tareas.
- Una tarea puede recibir múltiples entregas.
- Una entrega puede tener una evaluación.
- Un alumno puede registrar múltiples pagos.

### 6. Reglas iniciales de negocio

1. Cada usuario tendrá un identificador único.
2. Los correos electrónicos deberán ser únicos.
3. Las contraseñas nunca se almacenarán en texto plano.
4. Los permisos dependerán de los roles asignados.
5. Un tutor solo podrá consultar alumnos vinculados
   y autorizados.
6. Las inscripciones relacionarán alumnos con grupos.
7. Las entregas deberán pertenecer a alumnos inscritos.
8. Los pagos tendrán un estado verificable.
9. Las operaciones importantes deberán permitir
   trazabilidad y auditoría.

### 7. Consideraciones de seguridad

- Contraseñas almacenadas mediante hashes seguros.
- Consultas SQL parametrizadas.
- Validación de entradas.
- Control de acceso basado en roles.
- Protección de información personal.
- Variables de entorno para credenciales.
- Respaldos y recuperación de datos.

### 8. Próximos pasos

- Definir columnas y tipos de datos.
- Establecer claves primarias y foráneas.
- Crear el diagrama entidad-relación.
- Diseñar migraciones SQL.
- Implementar y probar las primeras tablas.

### 9. Diseño lógico — Módulo de identidad

#### 9.1 Tabla users

| Campo | Tipo | Restricciones |
|---|---|---|
| id | UUID | PRIMARY KEY |
| first_name | VARCHAR(100) | NOT NULL |
| last_name | VARCHAR(150) | NOT NULL |
| email | VARCHAR(255) | NOT NULL, UNIQUE |
| password_hash | TEXT | NOT NULL |
| is_active | BOOLEAN | NOT NULL, DEFAULT TRUE |
| created_at | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() |
| updated_at | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() |

#### 9.2 Tabla roles

| Campo | Tipo | Restricciones |
|---|---|---|
| id | SMALLINT | PRIMARY KEY |
| name | VARCHAR(50) | NOT NULL, UNIQUE |
| description | TEXT | Opcional |

Roles iniciales:
- admin
- teacher
- student
- guardian

#### 9.3 Tabla user_roles

| Campo | Tipo | Restricciones |
|---|---|---|
| user_id | UUID | NOT NULL, FK users(id) |
| role_id | SMALLINT | NOT NULL, FK roles(id) |
| assigned_at | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() |

Clave primaria compuesta:
(user_id, role_id)

#### 9.4 Relaciones

- users 1:N user_roles
- roles 1:N user_roles
- users N:M roles, mediante user_roles

#### 9.5 Reglas de integridad

1. El correo electrónico debe ser único sin distinguir
   mayúsculas y minúsculas.
2. Las contraseñas se almacenarán únicamente como hashes.
3. Un usuario puede tener múltiples roles.
4. No se permiten asignaciones duplicadas de roles.
5. La eliminación de usuarios deberá considerar
   sus relaciones académicas y registros históricos.
6. La fecha updated_at deberá actualizarse cuando
   se modifique el registro.

### 10. Diseño lógico — Relación alumno-tutor

#### 10.1 Tabla student_guardians

| Campo | Tipo | Restricciones |
|---|---|---|
| student_id | UUID | NOT NULL, FK users(id) |
| guardian_id | UUID | NOT NULL, FK users(id) |
| relationship | VARCHAR(30) | NOT NULL |
| is_authorized | BOOLEAN | NOT NULL, DEFAULT FALSE |
| created_at | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() |
| authorized_at | TIMESTAMPTZ | Opcional |

Clave primaria compuesta:
(student_id, guardian_id)

#### 10.2 Relaciones

- users (alumnos) 1:N student_guardians
- users (tutores) 1:N student_guardians
- Alumnos N:M tutores, mediante student_guardians

#### 10.3 Reglas de negocio

1. Un alumno puede tener múltiples tutores.
2. Un tutor puede estar vinculado con múltiples alumnos.
3. Un usuario no puede ser tutor de sí mismo.
4. Solo los vínculos autorizados permitirán
   consultar información académica.
5. El sistema deberá verificar que los usuarios
   tengan los roles correspondientes.
6. La autorización deberá realizarse mediante
   un proceso verificable.
7. La revocación del acceso deberá impedir
   futuras consultas de información protegida.
8. Los cambios de autorización deberán quedar
   registrados para auditoría.

#### 10.4 Reglas de integridad

- PRIMARY KEY (student_id, guardian_id)
- FOREIGN KEY student_id REFERENCES users(id)
- FOREIGN KEY guardian_id REFERENCES users(id)
- CHECK (student_id <> guardian_id)
- CHECK (relationship <> '')
- CHECK (NOT is_authorized OR authorized_at IS NOT NULL)

#### 10.5 Consideraciones de privacidad

- El parentesco declarado no implica autorización.
- Un tutor no podrá consultar alumnos ajenos.
- La autorización deberá comprobarse antes
  de entregar información académica.
- Se evitará exponer datos personales innecesarios.
- Las autorizaciones y revocaciones deberán
  conservar trazabilidad.

### 11. Diseño lógico — Módulo académico

#### 11.1 Tabla subjects

| Campo | Tipo | Restricciones |
|---|---|---|
| id | UUID | PRIMARY KEY |
| name | VARCHAR(150) | NOT NULL |
| description | TEXT | Opcional |
| is_active | BOOLEAN | NOT NULL, DEFAULT TRUE |
| created_at | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() |

#### 11.2 Tabla groups

| Campo | Tipo | Restricciones |
|---|---|---|
| id | UUID | PRIMARY KEY |
| subject_id | UUID | NOT NULL, FK subjects(id) |
| teacher_id | UUID | NOT NULL, FK users(id) |
| name | VARCHAR(150) | NOT NULL |
| capacity | INTEGER | NOT NULL |
| status | VARCHAR(30) | NOT NULL, DEFAULT 'planned' |
| created_at | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() |

Estados previstos:
- planned
- active
- completed
- cancelled

#### 11.3 Tabla enrollments

| Campo | Tipo | Restricciones |
|---|---|---|
| id | UUID | PRIMARY KEY |
| student_id | UUID | NOT NULL, FK users(id) |
| group_id | UUID | NOT NULL, FK groups(id) |
| status | VARCHAR(30) | NOT NULL, DEFAULT 'active' |
| enrolled_at | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() |

Estados previstos:
- active
- completed
- withdrawn

#### 11.4 Tabla classes

| Campo | Tipo | Restricciones |
|---|---|---|
| id | UUID | PRIMARY KEY |
| group_id | UUID | NOT NULL, FK groups(id) |
| title | VARCHAR(200) | NOT NULL |
| description | TEXT | Opcional |
| starts_at | TIMESTAMPTZ | NOT NULL |
| ends_at | TIMESTAMPTZ | NOT NULL |
| meeting_url | TEXT | Opcional |
| status | VARCHAR(30) | NOT NULL, DEFAULT 'scheduled' |

Estados previstos:
- scheduled
- completed
- cancelled

#### 11.5 Relaciones

- subjects 1:N groups
- users (profesores) 1:N groups
- groups 1:N enrollments
- users (alumnos) 1:N enrollments
- groups 1:N classes
- users (alumnos) N:M groups mediante enrollments

#### 11.6 Reglas de negocio

1. Cada grupo pertenece a una materia.
2. Cada grupo tiene un profesor responsable.
3. El profesor debe tener el rol teacher.
4. Un alumno puede inscribirse en varios grupos.
5. Un alumno no puede tener dos inscripciones
   simultáneamente activas en el mismo grupo.
6. El cupo de un grupo debe ser mayor que cero.
7. Las inscripciones activas no deben superar
   la capacidad del grupo.
8. La fecha de finalización de una clase debe
   ser posterior a su fecha de inicio.
9. Los enlaces de videollamada solo podrán ser
   consultados por usuarios autorizados.
10. Los cambios de profesor e inscripciones
    deberán conservar trazabilidad.

#### 11.7 Restricciones previstas

- CHECK (capacity > 0)
- CHECK (ends_at > starts_at)
- CHECK de valores permitidos para estados
- Índice único parcial para evitar inscripciones
  activas duplicadas por alumno y grupo
- Validación transaccional del cupo disponible
- Verificación de roles desde la aplicación
  y los servicios correspondientes

#### 11.8 Consideraciones futuras

- Horarios recurrentes de clases.
- Calendario académico.
- Sustituciones de profesores.
- Historial de cambios.
- Control de asistencia.
- Integración con Microsoft Teams o Google Meet.
- Políticas de acceso a enlaces de videollamadas.

### 12. Diseño lógico — Tareas y evaluaciones

#### 12.1 Tabla assignments

| Campo | Tipo | Restricciones |
|---|---|---|
| id | UUID | PRIMARY KEY |
| group_id | UUID | NOT NULL, FK groups(id) |
| title | VARCHAR(200) | NOT NULL |
| instructions | TEXT | NOT NULL |
| published_at | TIMESTAMPTZ | Opcional |
| due_at | TIMESTAMPTZ | NOT NULL |
| max_score | NUMERIC(6,2) | NOT NULL |
| status | VARCHAR(30) | NOT NULL, DEFAULT 'draft' |
| created_at | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() |

Estados previstos:
- draft
- published
- closed

#### 12.2 Tabla submissions

| Campo | Tipo | Restricciones |
|---|---|---|
| id | UUID | PRIMARY KEY |
| assignment_id | UUID | NOT NULL, FK assignments(id) |
| student_id | UUID | NOT NULL, FK users(id) |
| content | TEXT | Opcional |
| file_url | TEXT | Opcional |
| submitted_at | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() |
| status | VARCHAR(30) | NOT NULL, DEFAULT 'submitted' |

Estados previstos:
- submitted
- late
- reviewed

Restricción:
UNIQUE (assignment_id, student_id)

#### 12.3 Tabla grades

| Campo | Tipo | Restricciones |
|---|---|---|
| id | UUID | PRIMARY KEY |
| submission_id | UUID | NOT NULL, UNIQUE, FK submissions(id) |
| graded_by | UUID | NOT NULL, FK users(id) |
| score | NUMERIC(6,2) | NOT NULL |
| feedback | TEXT | Opcional |
| graded_at | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() |

#### 12.4 Relaciones

- groups 1:N assignments
- assignments 1:N submissions
- users (alumnos) 1:N submissions
- submissions 1:0..1 grades
- users (profesores) 1:N grades

#### 12.5 Reglas de negocio

1. Solo los profesores autorizados podrán publicar
   tareas en sus grupos.
2. Los alumnos solo podrán consultar tareas
   de los grupos donde estén inscritos.
3. Un alumno solo podrá entregar una vez
   cada actividad, con edición permitida
   antes de la fecha límite.
4. Cada entrega deberá incluir texto o archivo.
5. Las tareas no publicadas serán invisibles
   para los alumnos.
6. El puntaje máximo deberá ser mayor que cero.
7. Las calificaciones deberán estar entre cero
   y el puntaje máximo de la actividad.
8. Solo profesores autorizados podrán evaluar.
9. Los tutores autorizados podrán consultar
   los resultados de sus alumnos vinculados.
10. Las modificaciones de calificaciones
    deberán conservar historial de auditoría.

#### 12.6 Restricciones previstas

- CHECK (max_score > 0)
- CHECK (score >= 0)
- CHECK de estados permitidos
- UNIQUE (assignment_id, student_id)
- UNIQUE (submission_id) en grades
- Validación de score <= max_score mediante
  lógica transaccional o mecanismo de BD
- Validación de pertenencia del alumno al grupo
- Validación de permisos del profesor

#### 12.7 Consideraciones de archivos

- Los archivos se almacenarán en un servicio
  de almacenamiento privado.
- PostgreSQL conservará referencias y metadatos.
- No se expondrán enlaces privados permanentes.
- Se validarán tamaño y tipo de archivo.
- Las descargas requerirán autorización.
- Se definirán políticas de retención y borrado.

#### 12.8 Mejoras futuras

- Entregas con múltiples archivos.
- Historial de versiones.
- Múltiples intentos por actividad.
- Rúbricas de evaluación.
- Evaluaciones automáticas.
- Notificaciones de fechas límite.
- Reportes de rendimiento académico.

### 13. Diseño lógico — Cobros y pagos

#### 13.1 Objetivo

Registrar los cobros generados por servicios
académicos y los pagos asociados.

El módulo permitirá consultar saldos pendientes,
pagos confirmados y movimientos históricos.

#### 13.2 Tabla charges

| Campo | Tipo | Restricciones |
|---|---|---|
| id | UUID | PRIMARY KEY |
| student_id | UUID | NOT NULL, FK users(id) |
| enrollment_id | UUID | Opcional, FK enrollments(id) |
| description | VARCHAR(255) | NOT NULL |
| amount | NUMERIC(12,2) | NOT NULL |
| currency | CHAR(3) | NOT NULL, DEFAULT 'MXN' |
| due_at | TIMESTAMPTZ | Opcional |
| status | VARCHAR(30) | NOT NULL, DEFAULT 'pending' |
| created_at | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() |

Estados previstos:
- pending
- partially_paid
- paid
- cancelled

#### 13.3 Tabla payments

| Campo | Tipo | Restricciones |
|---|---|---|
| id | UUID | PRIMARY KEY |
| charge_id | UUID | NOT NULL, FK charges(id) |
| amount | NUMERIC(12,2) | NOT NULL |
| currency | CHAR(3) | NOT NULL, DEFAULT 'MXN' |
| method | VARCHAR(30) | NOT NULL |
| status | VARCHAR(30) | NOT NULL, DEFAULT 'pending' |
| provider | VARCHAR(50) | Opcional |
| provider_reference | VARCHAR(255) | Opcional |
| paid_at | TIMESTAMPTZ | Opcional |
| created_at | TIMESTAMPTZ | NOT NULL, DEFAULT NOW() |

Métodos previstos:
- bank_transfer
- card
- cash
- other

Estados previstos:
- pending
- succeeded
- failed
- refunded

#### 13.4 Relaciones

- users (alumnos) 1:N charges
- enrollments 1:N charges
- charges 1:N payments

#### 13.5 Reglas de negocio

1. Cada cobro pertenece a un alumno.
2. Un cobro puede tener múltiples pagos asociados.
3. El importe de un cobro debe ser mayor que cero.
4. El importe de cada pago debe ser mayor que cero.
5. Solo los pagos confirmados se contabilizarán
   como dinero recibido.
6. El saldo pendiente se calculará a partir
   del cobro y sus movimientos confirmados.
7. El sistema deberá impedir que pagos
   concurrentes excedan el saldo permitido.
8. Los pagos no podrán confirmarse únicamente
   mediante información enviada por el navegador.
9. Las confirmaciones de proveedores externos
   deberán verificarse en el servidor.
10. Los movimientos financieros deberán conservar
    trazabilidad y controles de acceso.
11. La moneda del pago deberá coincidir con
    la moneda del cobro.
12. Las devoluciones deberán quedar registradas
    sin eliminar el historial original.

#### 13.6 Restricciones previstas

- CHECK (amount > 0) en charges
- CHECK (amount > 0) en payments
- CHECK de estados permitidos
- CHECK de métodos de pago permitidos
- Índice sobre charges(student_id)
- Índice sobre payments(charge_id)
- Índice único para referencias externas
  cuando corresponda al proveedor
- Validación transaccional de saldos
- Verificación de idempotencia de operaciones

#### 13.7 Consideraciones de seguridad

- No almacenar números completos de tarjetas.
- No almacenar CVV ni credenciales bancarias.
- Utilizar proveedores especializados para
  procesar pagos electrónicos.
- Verificar firmas de webhooks.
- Proteger las credenciales mediante variables
  de entorno.
- Restringir la información financiera según
  el rol y la autorización correspondiente.
- Registrar operaciones administrativas sensibles.

#### 13.8 Decisiones pendientes

- Definir precios y planes académicos.
- Definir periodicidad de cobros.
- Establecer políticas de cancelación.
- Diseñar descuentos y becas.
- Elegir proveedor de pagos.
- Definir facturación y requisitos fiscales.
- Diseñar el registro contable de reembolsos.
- Definir conciliación de pagos y estados.
