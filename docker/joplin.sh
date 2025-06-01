mkdir -p /volume1/docker/joplin && cd /volume1/docker/joplin

cat <<EOF > docker-compose.yml
version: '3'

services:
  db:
    image: postgres:15
    volumes:
      - ./data:/var/lib/postgresql/data
    restart: unless-stopped
    environment:
      POSTGRES_PASSWORD: joplin
      POSTGRES_USER: joplin
      POSTGRES_DB: joplin

  app:
    image: joplin/server:latest
    depends_on:
      - db
    ports:
      - "22300:22300"
    restart: unless-stopped
    environment:
      APP_PORT: 22300
      APP_BASE_URL: http://192.168.88.111:22300
      DB_CLIENT: pg
      POSTGRES_PASSWORD: joplin
      POSTGRES_DATABASE: joplin
      POSTGRES_USER: joplin
      POSTGRES_PORT: 5432
      POSTGRES_HOST: db
EOF

docker compose up -d
