
FROM python:3.12-slim
ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFERED=1
RUN apt-get update && apt-get install -y --no-install-recommends ffmpeg unzip ca-certificates && rm -rf /var/lib/apt/lists/*
WORKDIR /tmp/package
COPY ryzer_downloader.zip /tmp/package/ryzer_downloader.zip
RUN mkdir -p /app && unzip -q /tmp/package/ryzer_indirici.zip -d /app && rm -rf /tmp/package
WORKDIR /app/ryzer_downloader
RUN pip install --no-cache-dir -r requirements.txt && mkdir -p /app/data/downloads
ENV DB_PATH=/app/data/history.sqlite3
ENV DOWNLOAD_DIR=/app/data/downloads
EXPOSE 8080
CMD ["sh", "-c", "gunicorn --workers 2 --threads 4 --timeout 3600 --bind 0.0.0.0:${PORT:-8080} app:app"]
