#!/usr/bin/env python3 
import pika

credentials = pika.PlainCredentials('rabbit', 'P@ssw0rd')
connection = pika.BlockingConnection(pika.ConnectionParameters('localhost', '5672', credentials=credentials))
channel = connection.channel() 
channel.queue_declare(queue='hello')
channel.basic_publish(exchange='', routing_key='hello', body='HelloRabbit!')
connection.close()
