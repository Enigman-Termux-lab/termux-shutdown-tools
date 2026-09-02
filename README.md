<div align="center">

# ⚡ Termux Shutdown Tools

### *Чистый экзит процессов, предотвращение утечек батареи и управление Wakelock в Android Termux*

[![Termux](https://img.shields.io/badge/Termux-Android-000000?style=for-the-badge&logo=termux&logoColor=white)](https://termux.dev/)
[![Battery Saver](https://img.shields.io/badge/Android-Battery_Saver-4EAA25?style=for-the-badge&logo=android&logoColor=white)](https://www.android.com/)
[![Bash](https://img.shields.io/badge/Bash-Automation-2B35AF?style=for-the-badge&logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](LICENSE)

<br/>

**Termux Shutdown Tools** — набор системных утилит и архитектурных рецептов для надежного завершения фоновых серверов, устранения «процессов-зомби» (PPID=1) и бережного управления зарядом аккумулятора смартфона.

---

</div>

## 🔋 В чём скрытая проблема Termux?

Многие пользователи считают, что нажатие кнопки **«Exit»** в шторке уведомлений Android закрывает Termux. Это опасное заблуждение:
1. **Скрипты из виджетов (`~/.shortcuts/`) уходят под init (PPID=1):** Они становятся демонами операционной системы Android.
2. **Фоновый жор батареи:** Серверы Node.js, Python Uvicorn, ngrok и AI-агенты продолжают скрыто работать в фоне, греть процессор и разряжать аккумулятор.
3. **Занятые порты:** При повторном открытии вы получаете ошибку `address already in use` (порт 8000/3000 занят старым невидимым процессом).

---

## 🛠 Инструменты репозитория

В папке [`scripts/`](scripts/) собраны решения для полного контроля над процессами:

### 1. [`scripts/kill-all.sh`](scripts/kill-all.sh) — Полный двухфазный экзит
Выполняет 100% чистую остановку Termux:
1. Посылает сигнал `SIGTERM` всем процессам пользователя для штатного сохранения данных;
2. Ожидает 1 секунду и отправляет `SIGKILL` зависшим процессам;
3. Вызывает `am force-stop com.termux` — система Android полностью освобождает оперативную память.
> 💡 *Рекомендуется повесить ярлык `kill-all.sh` на рабочий стол Android через Termux:Widget!*

### 2. [`scripts/wakelock-toggle.sh`](scripts/wakelock-toggle.sh) — Умный переключатель Wakelock
- **Когда нужен сервер:** Нажмите переключатель — процессор смартфона не уйдет в глубокий сон (`termux-wake-lock`), а MCP-мосты и AI-агенты будут стабильно отвечать.
- **Когда работа окончена:** Нажмите еще раз — блокировка сна снимется (`termux-wake-unlock`), сохраняя аккумулятор на весь день.

### 3. [`scripts/safe-shutdown.sh`](scripts/safe-shutdown.sh) — Мягкая остановка серверов
Точечно останавливает только веб-серверы и демоны (`uvicorn`, `ngrok`, `codex`), не закрывая саму сессию терминала.

---

## 🚀 Быстрая установка

```bash
git clone https://github.com/Enigman-Termux-lab/termux-shutdown-tools.git
cd termux-shutdown-tools

# Создание ярлыков для Termux:Widget:
mkdir -p ~/.shortcuts
cp scripts/kill-all.sh scripts/wakelock-toggle.sh ~/.shortcuts/
chmod 700 ~/.shortcuts/kill-all.sh ~/.shortcuts/wakelock-toggle.sh
```

---

## 📄 Лицензия

Распространяется под лицензией [MIT](LICENSE). Разработано для открытой экосистемы **[Enigman-Termux-lab](https://github.com/Enigman-Termux-lab)**.
