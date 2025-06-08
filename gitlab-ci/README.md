
### Задание 1

**Что нужно сделать:**

1. Разверните GitLab локально, используя Vagrantfile и инструкцию, описанные в [этом репозитории](https://github.com/netology-code/sdvps-materials/tree/main/gitlab).   
2. Создайте новый проект и пустой репозиторий в нём.
3. Зарегистрируйте gitlab-runner для этого проекта и запустите его в режиме Docker. Раннер можно регистрировать и запускать на той же виртуальной машине, на которой запущен GitLab.

В качестве ответа в репозиторий шаблона с решением добавьте скриншоты с настройками раннера в проекте.

**/srv/gitlab-runner/config/config.toml**
```
concurrent = 3
check_interval = 0
shutdown_timeout = 0

[[runners]]
  name = "runner"
  url = "http://192.168.77.106/"
  id = 1
  token = "glrt-KvR1Skh4Yd3LsTZclLAMp286MQpwOjEKdDozCnU6MQ8.01.171r7w8ym"
  executor = "docker"
  [runners.docker]
    tls_verify = false
    image = "golang:1.17"
    volumes = ["/cache", "/var/run/docker.sock:/var/run/docker.sock"]
```
![task1](task1.png)

---

### Задание 2

**Что нужно сделать:**

1. Запушьте [репозиторий](https://github.com/netology-code/sdvps-materials/tree/main/gitlab) на GitLab, изменив origin. Это изучалось на занятии по Git.
2. Создайте .gitlab-ci.yml, описав в нём все необходимые, на ваш взгляд, этапы.

В качестве ответа в шаблон с решением добавьте: 
   
 * файл gitlab-ci.yml для своего проекта или вставьте код в соответствующее поле в шаблоне; 
 * скриншоты с успешно собранными сборками.
 
```
stages:
  - test
  - build

test:
  stage: test
  image: golang:1.17
  script: 
   - go test 
  tags:
    - fox

build:
  stage: build
  image: docker:latest
  script:
   - docker build .
  tags:
    - fox
```
 

---
## Дополнительные задания* (со звёздочкой)

Их выполнение необязательное и не влияет на получение зачёта по домашнему заданию. Можете их решить, если хотите лучше разобраться в материале.

---

### Задание 3*

Измените CI так, чтобы:

 - этап сборки запускался сразу, не дожидаясь результатов тестов;
 - тесты запускались только при изменении файлов с расширением *.go.

В качестве ответа добавьте в шаблон с решением файл gitlab-ci.yml своего проекта или вставьте код в соответсвующее поле в шаблоне.
