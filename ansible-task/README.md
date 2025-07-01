# «Ansible.Часть 2»

### Задание 1

**Выполните действия, приложите файлы с плейбуками и вывод выполнения.**

Напишите три плейбука. При написании рекомендуем использовать текстовый редактор с подсветкой синтаксиса YAML.

Плейбуки должны: 

1. Скачать какой-либо архив, создать папку для распаковки и распаковать скаченный архив. Например, можете использовать [официальный сайт](https://kafka.apache.org/downloads) и зеркало Apache Kafka. При этом можно скачать как исходный код, так и бинарные файлы, запакованные в архив — в нашем задании не принципиально.
2. Установить пакет tuned из стандартного репозитория вашей ОС. Запустить его, как демон — конфигурационный файл systemd появится автоматически при установке. Добавить tuned в автозагрузку.
3. Изменить приветствие системы (motd) при входе на любое другое. Пожалуйста, в этом задании используйте переменную для задания приветствия. Переменную можно задавать любым удобным способом.


### Задание 2

**Выполните действия, приложите файлы с модифицированным плейбуком и вывод выполнения.** 

Модифицируйте плейбук из пункта 3, задания 1. В качестве приветствия он должен установить IP-адрес и hostname управляемого хоста, пожелание хорошего дня системному администратору. 

```
---
- name: TASK 1-2
  hosts: all
  become: true
  vars:
    user: fox
    welcome: "Hello {{ user }}, have a good day!"
  tasks:

  - name: Create directory
    ansible.builtin.file:
      path: /home/{{ user }}/apache
      state: directory
  
  - name: Download Apache
    ansible.builtin.get_url:
      url: https://dlcdn.apache.org/kafka/3.9.1/kafka_2.13-3.9.1.tgz
      dest: /home/{{ user }}/apache/kafka.tgz
    
  - name: Unpacking Apache archive
    ansible.builtin.unarchive:
      src: /home/{{ user }}/apache/kafka.tgz
      dest: /home/{{ user }}/apache/ 
      remote_src: yes
  
  - name: Install tuned packet
    ansible.builtin.package:
      name: tuned
      state: present 

  - name: Enable service tuned
    ansible.builtin.systemd_service:
      name: tuned
      enabled: true
      state: started

  - name: MOTD
    ansible.builtin.copy:
      content: |
        #!/bin/bash
        echo "Hostname:{{ ansible_facts['nodename'] }}"
        echo "IP_addr:  {{ ansible_facts.all_ipv4_addresses[0] }}"
        echo "{{ welcome }}"
      dest: /etc/update-motd.d/01-mycustom-motd
      mode: '0755'
```

### Задание 3

**Выполните действия, приложите архив с ролью и вывод выполнения.**

Ознакомьтесь со статьёй [«Ansible - это вам не bash»](https://habr.com/ru/post/494738/), сделайте соответствующие выводы и не используйте модули **shell** или **command** при выполнении задания.

Создайте плейбук, который будет включать в себя одну, созданную вами роль. Роль должна:

1. Установить веб-сервер Apache на управляемые хосты.
2. Сконфигурировать файл index.html c выводом характеристик каждого компьютера как веб-страницу по умолчанию для Apache. Необходимо включить CPU, RAM, величину первого HDD, IP-адрес.
Используйте [Ansible facts](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html) и [jinja2-template](https://linuxways.net/centos/how-to-use-the-jinja2-template-in-ansible/). Необходимо реализовать handler: перезапуск Apache только в случае изменения файла конфигурации Apache.
4. Открыть порт 80, если необходимо, запустить сервер и добавить его в автозагрузку.
5. Сделать проверку доступности веб-сайта (ответ 200, модуль uri).

В качестве решения:
- предоставьте плейбук, использующий роль;
- разместите архив созданной роли у себя на Google диске и приложите ссылку на роль в своём решении;
- предоставьте скриншоты выполнения плейбука;
- предоставьте скриншот браузера, отображающего сконфигурированный index.html в качестве сайта.

```
---
- name: Install apache
  ansible.builtin.package:
    name: apache2
    state: present

- name: Enable service apache
  ansible.builtin.systemd_service:
    name: apache2
    enabled: true
    state: started

- name: Set new index.html file
  ansible.builtin.template:
    src: apache.conf.j2
    dest: /var/www/html/index.html
  notify:
    - Restart apache2

- name: Allow all access to tcp port 22
  community.general.ufw:
    rule: allow
    port: '22'
    proto: tcp

- name: Allow all access to tcp port 80
  community.general.ufw:
    rule: allow
    port: '80'
    proto: tcp

- name: Allow all outgoing traffic
  community.general.ufw:
    rule: allow
    direction: "out"

- name: Block all incoming
  community.general.ufw:
    rule: deny
    direction: "in"

- name: Enable UFW
  community.general.ufw:
    state: enabled

- name: Check that you can connect (GET) to a page and it returns a status 200
  ansible.builtin.uri:
    url: http://{{ ansible_host }}
    status_code: 200
    remote_src: false
  delegate_to: localhost
  become: false
```

**Полезные команды:**
```
ansible-config init --disabled -t all > ansible.cfg            # Generating ansible.cfg
ansible <hostname or group_name>> -m ansible.builtin.setup     # Gathere information about host
ansible <hostname or group_name> -m ping                       # Check connection
ansible-playbook <hostname or group_name>  
```

### Result
[Screenshots](https://docs.google.com/document/d/1KrDogewX8G2hU_a5boCF-zpUorL0bZW-VlITRTCsfSY/edit?usp=sharing)
[Ansible archive](https://drive.google.com/file/d/1xId-nPxjn5bKO8Sd3Con1VZRADJappMS/view?usp=sharing)

