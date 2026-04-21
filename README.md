# Bugflow (Elixir / Phoenix backend)

A Bugflow egy REST alapú backend alkalmazás Elixir/Phoenix stackkel, amely workspace-ekhez tartozó issue-k kezelésére szolgál.

## Stack

- Elixir
- Phoenix Framework
- Ecto
- PostgreSQL
- ExUnit

## Funkciók

- Issue CRUD műveletek
- Workspace – Issue reláció (1:N)
- Szűrés:
  - workspace_id
  - status
  - priority
  - kombinált szűrés
- Rendezés:
  - inserted_at (asc/desc)
  - priority (asc/desc)
- Automatizált tesztek (38+)

## Példa endpointok

### Összes issue lekérése
GET /api/issues

### Szűrés workspace szerint
GET /api/issues?workspace_id=<id>

### Szűrés státusz szerint
GET /api/issues?status=open

### Kombinált szűrés
GET /api/issues?workspace_id=<id>&status=open

### Rendezés
GET /api/issues?sort=inserted_at_desc

## Telepítés

```bash
mix deps.get
mix ecto.setup
mix phx.server