-- DDL de ejemplo para la practica.
-- Objetivo:
-- - dejar una tabla minima de control,
-- - y preparar datos para el backend Python.

CREATE TABLE IF NOT EXISTS healthcheck (
  id SERIAL PRIMARY KEY,
  created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO healthcheck DEFAULT VALUES;

CREATE TABLE IF NOT EXISTS favorite_colors (
  name VARCHAR(20) PRIMARY KEY,
  color VARCHAR(20)
);

INSERT INTO favorite_colors (name, color)
VALUES
  ('Lancelot', 'blue'),
  ('Galahad', 'yellow')
ON CONFLICT DO NOTHING;
