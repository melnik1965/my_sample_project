#!/bin/bash
# Подстановка команды (command substitution) в bash. 
# Она выполняет команду внутри $() и подставляет её вывод 
# прямо в строку
# $(date +%Y-%m-%d) 
TODAY=$(date +%Y-%m-%d)
echo "Сегодня: $TODAY"