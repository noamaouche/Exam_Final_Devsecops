FROM python:3.11-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# COPY requirements en premier = exploitation du cache Docker
# Si app.py change mais pas requirements.txt -> ce layer reste en cache
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copie du code source après les deps
COPY . .

# Utilisateur non-root pour le principe de moindre privilege
RUN useradd -m -u 1001 appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--workers", "2", "app:app"]
