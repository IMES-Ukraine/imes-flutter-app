# IMES
Спецификафия системы IMES mvp1.0

## BACKEND

Backend представлен HTTP REST API и websocket

![Main sceme](imgs/main-scheme.png)

[https://www.figma.com/file/hItQHEsFvnJsw0og6jMSfB/Flow-Chart-(Copy)?node-id=59411%3A0](https://www.figma.com/file/hItQHEsFvnJsw0og6jMSfB/Flow-Chart-(Copy)?node-id=59411%3A0)

## REST API IMES-MAIN

[Click to import IMES API Isomnia file](files/IMES-API.json)

IMES-MAIN API охватывает почти весь основной функционал приложения, IMES-MESSAGING предназначен только для доставки сообщений между пользователеми платформы

## IMES-MESSAGING

### Хранение сообщений и медиа

Перзистентное хранилище - кластер cockroachdb, хранит в себе тексты сообщений

Тест сообщений бывает нескольких типов в зависимости от содержимого, он закодирован следующим образом

|         Тип | Сообщение        |
|------------:|------------------|
| text        | this is plain text  |
| file        | file:attach1234  |
| photos      | photo:attach1234 |
| voice input | voice:attach1234 |

# DESIGN

[Link to figma design file 1 (Logos and other)](https://www.figma.com/file/md4HekNIpdFN7fPQMHkhcP/IMES-tracker?node-id=0%3A1)

[Link to figma design file 2 (Main)](https://www.figma.com/file/P0NhIXZxjNCzLpZuqLKwWQ/IMES-app-(MVP)?node-id=0%3A1)





