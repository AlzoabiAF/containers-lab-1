# Практическая работа №1 — контейнеризация

В рамках работы выполнены контейнеризация веб-приложения (Go API + Nginx + PostgreSQL), сборка образов через многоэтапный Dockerfile, оркестрация сервисов в Docker Compose и настройка CI/CD в GitHub Actions с публикацией образов в GitHub Container Registry (GHCR).

Подробный отчёт со скриншотами и выводами команд Docker приведён в [REPORT.md](REPORT.md).

## Итоги

Развёрнуто рабочее веб-приложение в контейнерах (API на Go, Nginx как reverse proxy, PostgreSQL с инициализацией через init-скрипты), образы собираются и публикуются в GHCR по push через GitHub Actions. Локальный запуск и тесты выполняются через `docker compose` (в том числе сценарий `docker-compose.test.yml`).
