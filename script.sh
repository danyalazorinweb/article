#!/bin/bash
if [ "$EUID" -ne 0 ]; then
    echo "Этот скрипт должен быть запущен от имени суперпользователя."
    exit 1
fi

if ! command -v cryptsetup &> /dev/null; then
    echo "Утилита cryptsetup не найдена. Установите ее перед запуском скрипта."
    exit 1
fi

encrypt_disk() {
    local disk="$1"
    local password="$2"
    local cipher="aes-xts-plain64"
    local key_size="256"

    echo "Шифрование диска $disk с использованием AES алгоритма..."

    local start_time=$(date +%s)

    echo "$password" | cryptsetup -q luksFormat --type luks2 --cipher "$cipher" --key-size "$key_size" "$disk" -

    local end_time=$(date +%s)
    local elapsed_time=$((end_time - start_time))
    echo "Затраченное время: $elapsed_time секунд"

    echo "Шифрование завершено."
}


read -p "Укажите путь к диску, который необходимо зашифровать: " disk_path
read -sp "Введите пароль для зашифровки: " password
echo ""

encrypt_disk "$disk_path" "$password"