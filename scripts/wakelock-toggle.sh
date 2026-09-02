#!/data/data/com.termux/files/usr/bin/bash
# ==============================================================================
# Termux Shutdown Tools — Wakelock Toggle
# Переключение блокировки засыпания процессора Android (Wakelock)
# ==============================================================================
set -u

STATE_FILE="$HOME/.termux_wakelock_state"

notify() {
    if command -v termux-toast >/dev/null 2>&1; then
        termux-toast "$1" >/dev/null 2>&1 || true
    fi
}

if [ -f "$STATE_FILE" ]; then
    termux-wake-unlock >/dev/null 2>&1 || true
    rm -f "$STATE_FILE"
    notify "🔋 Wakelock выключен: CPU может засыпать"
else
    termux-wake-lock >/dev/null 2>&1 || true
    touch "$STATE_FILE"
    notify "⚡ Wakelock включён: фоновые вычисления активны 24/7"
fi
