#!/usr/bin/env bash
# One-time setup run by the dev container after it is created.
set -euo pipefail

cd "$(dirname "$0")/.."

echo "==> Installing dependencies"
npm ci

if [ ! -f apps/backend/.env ]; then
  echo "==> Creating apps/backend/.env with local dev defaults"
  printf '%s\n' \
    'DATABASE_URL="file:./dev.db"' \
    'JWT_SECRET="dev-secret"' \
    > apps/backend/.env
fi

echo "==> Generating Prisma client and applying migrations"
npm run db:generate -w apps/backend
npx -w apps/backend prisma migrate deploy

echo
echo "DeepArch is ready. Run 'npm run dev' and open http://localhost:5173"
