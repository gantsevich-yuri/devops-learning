# «Кластеризация и балансировка нагрузки»

### Цель задания
В результате выполнения этого задания вы научитесь:
1. Настраивать балансировку с помощью HAProxy
2. Настраивать связку HAProxy + Nginx

------

### Задание 1
- Запустите два simple python сервера на своей виртуальной машине на разных портах
- Установите и настройте HAProxy, воспользуйтесь материалами к лекции 
- Настройте балансировку Round-robin на 4 уровне.
- На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy.

#### start python servers:
```
python3 -m http.server 8888 --bind 0.0.0.0
python3 -m http.server 9999 --bind 0.0.0.0
```

#### loadbalancer config:
[task1.cfg](https://github.com/gantsevich-yuri/devops-learning/blob/main/balancer/task1.cfg)

#### check loadbalancer:
```
curl -I localhost:8080
```

![task1](task1.png)

### Задание 2
- Запустите три simple python сервера на своей виртуальной машине на разных портах
- Настройте балансировку Weighted Round Robin на 7 уровне, чтобы первый сервер имел вес 2, второй - 3, а третий - 4
- HAproxy должен балансировать только тот http-трафик, который адресован домену example.local
- На проверку направьте конфигурационный файл haproxy, скриншоты, где видно перенаправление запросов на разные серверы при обращении к HAProxy c использованием домена example.local и без него.

#### loadbalancer config:
[task2.cfg](https://github.com/gantsevich-yuri/devops-learning/blob/main/balancer/task2.cfg)

#### check loadbalancer:
```
curl -I -H "Host: example.local" localhost
```

![task2](task2.png)

---

### Задание 3*
- Настройте связку HAProxy + Nginx как было показано на лекции.
- Настройте Nginx так, чтобы файлы .jpg выдавались самим Nginx (предварительно разместите несколько тестовых картинок в директории /var/www/), а остальные запросы переадресовывались на HAProxy, который в свою очередь переадресовывал их на два Simple Python server.
- На проверку направьте конфигурационные файлы nginx, HAProxy, скриншоты с запросами jpg картинок и других файлов на Simple Python Server, демонстрирующие корректную настройку.

#### nginx config:
[task3_nginx.cfg](https://github.com/gantsevich-yuri/devops-learning/blob/main/balancer/task3_nginx.cfg)

#### HAproxy config:
[task3_ha.cfg](https://github.com/gantsevich-yuri/devops-learning/blob/main/balancer/task3_ha.cfg)

![task3](task3.png)

---

### Задание 4*
- Запустите 4 simple python сервера на разных портах.
- Первые два сервера будут выдавать страницу index.html вашего сайта example1.local (в файле index.html напишите example1.local)
- Вторые два сервера будут выдавать страницу index.html вашего сайта example2.local (в файле index.html напишите example2.local)
- Настройте два бэкенда HAProxy
- Настройте фронтенд HAProxy так, чтобы в зависимости от запрашиваемого сайта example1.local или example2.local запросы перенаправлялись на разные бэкенды HAProxy
- На проверку направьте конфигурационный файл HAProxy, скриншоты, демонстрирующие запросы к разным фронтендам и ответам от разных бэкендов.

#### HAproxy config:
[task4.cfg](https://github.com/gantsevich-yuri/devops-learning/blob/main/balancer/task4.cfg)

![task4](task4.png)

------

## Result in Google Docs :white_check_mark:

[Nginx + HAproxy](https://docs.google.com/document/d/10h1YnYZCFbrbbmmhxDm4eqiOHmPC_YQ9dvt_H16to14/edit?usp=sharing)