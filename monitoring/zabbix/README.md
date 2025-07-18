# Система мониторинга Zabbix

### Задание 1 

Установите Zabbix Server с веб-интерфейсом.

#### Процесс выполнения
1. Выполняя ДЗ, сверяйтесь с процессом отражённым в записи лекции.
2. Установите PostgreSQL. Для установки достаточна та версия, что есть в системном репозитороии Debian 11.
3. Пользуясь конфигуратором команд с официального сайта, составьте набор команд для установки последней версии Zabbix с поддержкой PostgreSQL и Apache.
4. Выполните все необходимые команды для установки Zabbix Server и Zabbix Web Server.

#### Требования к результатам 
1. Прикрепите в файл README.md скриншот авторизации в админке.

[Result](https://docs.google.com/document/d/1bpL1Cxu1Gdy5qBaHJ5skIj7AKOwxWwL6rrfBT3fqpXw/edit?usp=sharing)

2. Приложите в файл README.md текст использованных команд в GitHub.
```
sudo -s
wget https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu22.04_all.deb
dpkg -i zabbix-release_latest_7.4+ubuntu22.04_all.deb
apt update

apt install zabbix-server-pgsql zabbix-frontend-php php8.1-pgsql zabbix-apache-conf zabbix-sql-scripts zabbix-agent postgresql

sudo -u postgres createuser --pwprompt zabbix # create DB user
sudo -u postgres createdb -O zabbix zabbix    # create DB 

zcat /usr/share/zabbix/sql-scripts/postgresql/server.sql.gz | sudo -u zabbix psql zabbix  # Initialize DB

/etc/zabbix/zabbix_server.conf # set DBPassword

systemctl restart zabbix-server apache2 # start server and web
systemctl enable zabbix-server apache2  # autostart server and web
```
---

### Задание 2 

Установите Zabbix Agent на два хоста.

#### Процесс выполнения
1. Выполняя ДЗ, сверяйтесь с процессом отражённым в записи лекции.
2. Установите Zabbix Agent на 2 вирт.машины, одной из них может быть ваш Zabbix Server.
3. Добавьте Zabbix Server в список разрешенных серверов ваших Zabbix Agentов.
4. Добавьте Zabbix Agentов в раздел Configuration > Hosts вашего Zabbix Servera.
5. Проверьте, что в разделе Latest Data начали появляться данные с добавленных агентов.

#### Требования к результатам
1. Приложите в файл README.md скриншот раздела Configuration > Hosts, где видно, что агенты подключены к серверу
2. Приложите в файл README.md скриншот лога zabbix agent, где видно, что он работает с сервером
3. Приложите в файл README.md скриншот раздела Monitoring > Latest data для обоих хостов, где видны поступающие от агентов данные.

[Result](https://docs.google.com/document/d/1bpL1Cxu1Gdy5qBaHJ5skIj7AKOwxWwL6rrfBT3fqpXw/edit?usp=sharing)

4. Приложите в файл README.md текст использованных команд в GitHub
```
wget https://repo.zabbix.com/zabbix/7.4/release/ubuntu/pool/main/z/zabbix-release/zabbix-release_latest_7.4+ubuntu22.04_all.deb
dpkg -i zabbix-release_latest_7.4+ubuntu22.04_all.deb
apt update

apt install zabbix-agent

vim /etc/zabbix/zabbix_agentd.conf
Server=[ server_ip ] # set Zabbix server ip
ServerActive=[ server_ip ] # set Zabbix server ip

systemctl restart zabbix-agent
systemctl enable zabbix-agent
```

---
## Задание 3 со звёздочкой*
Установите Zabbix Agent на Windows (компьютер) и подключите его к серверу Zabbix.

#### Требования к результатам
1. Приложите в файл README.md скриншот раздела Latest Data, где видно свободное место на диске C:
--- 

[Result](https://docs.google.com/document/d/1bpL1Cxu1Gdy5qBaHJ5skIj7AKOwxWwL6rrfBT3fqpXw/edit?usp=sharing)

## Критерии оценки

1. Выполнено минимум 2 обязательных задания
2. Прикреплены требуемые скриншоты и тексты 
3. Задание оформлено в шаблоне с решением и опубликовано на GitHub