#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# Termux Shutdown Tools — Safe Graceful Shutdown
# Мягкая остановка известных серверов (Uvicorn, Node, Python) с уведомлением
# ==============================================================================
set -u

notify() {
    if command -v termux-toast >/dev/null 2>&1; then
        termux-toast "$1" >/dev/null 2>&1 || true
    fi
}

notify "Мягкая остановка фоновых сервисов..."

# Останавливаем стандартные серверные процессы
pkill -TERM -f "uvicorn" 2>/dev/null || true
pkill -TERM -f "ngrok" 2>/dev/null || true
pkill -TERM -f "codex" 2>/dev/null || true
pkill -TERM -f "opencode" 2>/dev/null || true

sleep 1

notify "Серверы остановлены. Termux готов к закрытию."
