
# Academia Platform — Diagrama entidad-relación

## Versión conceptual 1.0

```mermaid
erDiagram
    users ||--o{ user_roles : has
    roles ||--o{ user_roles : assigns

    users ||--o{ student_guardians : student
    users ||--o{ student_guardians : guardian

    subjects ||--o{ groups : offers
    users ||--o{ groups : teaches

    groups ||--o{ enrollments : contains
    users ||--o{ enrollments : enrolls

    groups ||--o{ classes : schedules
    groups ||--o{ assignments : assigns

    assignments ||--o{ submissions : receives
    users ||--o{ submissions : submits

    submissions ||--o| grades : receives
    users ||--o{ grades : evaluates

    users ||--o{ charges : billed
    enrollments |o--o{ charges : generates
    charges ||--o{ payments : receives

    users {
        uuid id PK
        varchar first_name
        varchar last_name
        varchar email UK
        text password_hash
        boolean is_active
        timestamptz created_at
        timestamptz updated_at
    }

    roles {
        smallint id PK
        varchar name UK
        text description
    }

    user_roles {
        uuid user_id PK,FK
        smallint role_id PK,FK
        timestamptz assigned_at
    }

    student_guardians {
        uuid student_id PK,FK
        uuid guardian_id PK,FK
        varchar relationship
        boolean is_authorized
        timestamptz created_at
        timestamptz authorized_at
    }

    subjects {
        uuid id PK
        varchar name
        text description
        boolean is_active
        timestamptz created_at
    }

    groups {
        uuid id PK
        uuid subject_id FK
        uuid teacher_id FK
        varchar name
        int capacity
        varchar status
        timestamptz created_at
    }

    enrollments {
        uuid id PK
        uuid student_id FK
        uuid group_id FK
        varchar status
        timestamptz enrolled_at
    }

    classes {
        uuid id PK
        uuid group_id FK
        varchar title
        text description
        timestamptz starts_at
        timestamptz ends_at
        text meeting_url
        varchar status
    }

    assignments {
        uuid id PK
        uuid group_id FK
        varchar title
        text instructions
        timestamptz published_at
        timestamptz due_at
        numeric max_score
        varchar status
        timestamptz created_at
    }

    submissions {
        uuid id PK
        uuid assignment_id FK
        uuid student_id FK
        text content
        text file_url
        timestamptz submitted_at
        varchar status
    }

    grades {
        uuid id PK
        uuid submission_id FK,UK
        uuid graded_by FK
        numeric score
        text feedback
        timestamptz graded_at
    }

    charges {
        uuid id PK
        uuid student_id FK
        uuid enrollment_id FK
        varchar description
        numeric amount
        char currency
        timestamptz due_at
        varchar status
        timestamptz created_at
    }

    payments {
        uuid id PK
        uuid charge_id FK
        numeric amount
        char currency
        varchar method
        varchar status
        varchar provider
        varchar provider_reference
        timestamptz paid_at
        timestamptz created_at
    }
```

## Notas

- PK: clave primaria.
- FK: clave foránea.
- UK: restricción de unicidad.
- Las relaciones representan el diseño lógico inicial.
- Las restricciones avanzadas se implementarán
  mediante migraciones y lógica de negocio.
- Los permisos y autorizaciones se validarán
  desde el backend.
