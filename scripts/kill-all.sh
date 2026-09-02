#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# Termux Shutdown Tools — Complete Process Terminator (kill-all.sh)
# Корректное двухфазное завершение всех процессов Termux и закрытие приложения
# ==============================================================================
set -u

notify() {
    if command -v termux-toast >/dev/null 2>&1; then
        termux-toast "$1" >/dev/null 2>&1 || true
    fi
}

notify "Остановка всех процессов Termux..."

# Фаза 1: Отправляем SIGTERM всем дочерним процессам текущего пользователя
pkill -TERM -u "$(id -u)" 2>/dev/null || true

# Даем время на сохранение состояния и корректный выход демонов
sleep 1

# Фаза 2: Принудительный SIGKILL оставшимся зомби-процессам (исключая наш скрипт)
CURRENT_PID=$$
for pid in $(pgrep -u "$(id -u)" 2>/dev/null || true); do
    if [ "$pid" != "$CURRENT_PID" ]; then
        kill -9 "$pid" 2>/dev/null || true
    fi
done

# Закрываем само приложение Termux через Android Activity Manager
am force-stop com.termux >/dev/null 2>&1 || true
exit 0
