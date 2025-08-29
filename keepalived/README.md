# «Disaster recovery и Keepalived»

### Цель задания
В результате выполнения этого задания вы научитесь:
1. Настраивать отслеживание интерфейса для протокола HSRP;
2. Настраивать сервис Keepalived для использования плавающего IP

------

### Чеклист готовности к домашнему заданию

1. Установлена программа Cisco Packet Tracer
2. Установлена операционная система Ubuntu на виртуальную машину и имеется доступ к терминалу
3. Сделан клон этой виртуальной машины, они находятся в одной подсети и имеют разные IP адреса
4. Просмотрены конфигурационные файлы, рассматриваемые на лекции, которые находятся по [ссылке](1/)


------


### Задание 1
- Дана [схема](1/hsrp_advanced.pkt) для Cisco Packet Tracer, рассматриваемая в лекции.
- На данной схеме уже настроено отслеживание интерфейсов маршрутизаторов Gi0/1 (для нулевой группы)
- Необходимо аналогично настроить отслеживание состояния интерфейсов Gi0/0 (для первой группы).
- Для проверки корректности настройки, разорвите один из кабелей между одним из маршрутизаторов и Switch0 и запустите ping между PC0 и Server0.
- На проверку отправьте получившуюся схему в формате pkt и скриншот, где виден процесс настройки маршрутизатора.

------


### Задание 2
- Запустите две виртуальные машины Linux, установите и настройте сервис Keepalived как в лекции, используя пример конфигурационного [файла](1/keepalived-simple.conf).
- Настройте любой веб-сервер (например, nginx или simple python server) на двух виртуальных машинах
- Напишите Bash-скрипт, который будет проверять доступность порта данного веб-сервера и существование файла index.html в root-директории данного веб-сервера.
- Настройте Keepalived так, чтобы он запускал данный скрипт каждые 3 секунды и переносил виртуальный IP на другой сервер, если bash-скрипт завершался с кодом, отличным от нуля (то есть порт веб-сервера был недоступен или отсутствовал index.html). Используйте для этого секцию vrrp_script
- На проверку отправьте получившейся bash-скрипт и конфигурационный файл keepalived, а также скриншот с демонстрацией переезда плавающего ip на другой сервер в случае недоступности порта или файла index.html

### VRRP MASTER node
```
vrrp_script check_nginx {
        script "/home/fox/script.sh"
        interval 3
}

vrrp_instance VI_1 {
        state MASTER
        interface eth0
        virtual_router_id 1
        priority 250
        advert_int 1

        virtual_ipaddress {
                10.10.0.5/24
        }

	    unicast_peer {
                10.10.0.14
        }

        track_script {
                check_nginx
        }
}
```

### VRRP BACKUP node
```
vrrp_instance VI_1 {
        state BACKUP
        interface eth0
        virtual_router_id 1
        priority 200
        advert_int 1

        virtual_ipaddress {
                10.10.0.5/24
        }

	    unicast_peer {
                10.10.0.19
        }
}
```

### Script for VRRP
```
#!/bin/bash

file="/var/www/html/index.nginx-debian.html"

if [[ $(curl -s -w '%{http_code}\n' -o /dev/null localhost) != '200' || ! -f "file" ]]; then
        exit 1
else
        exit 0
fi;
```

## Result in Google Docs :white_check_mark:

[Disaster recovery и Keepalived](https://docs.google.com/document/d/1NsX91lWc677K_q-uvodTU5korzexkpqGh-edlYRa_ag/edit?usp=sharing)