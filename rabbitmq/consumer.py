#!/usr/bin/env python3
import pika

credentials = pika.PlainCredentials('rabbit', 'P@ssw0rd')
connection = pika.BlockingConnection(pika.ConnectionParameters('localhost', '5672', credentials=credentials))
channel = connection.channel() 
channel.queue_declare(queue='my-queue')

def callback(ch, method, properties, body):
    print(" [x] Received %r" % body)

channel.basic_consume(queue='my-queue', on_message_callback=callback,auto_ack=True)
channel.start_consuming()
