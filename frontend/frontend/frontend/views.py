from django.http import HttpResponse
from django.shortcuts import render, redirect
from django.conf import settings
import os

def index(request):
    return render(request, 'index.html')


def get_processed_messages():
    return "Similation"

def view_messages(request):
    if settings.MESSAGING_TYPE == 'rabbitmq':
        messages = get_processed_messages()
        return render(request, 'view.html', {'messages': messages})
    elif settings.MESSAGING_TYPE == 'pubsub':
        # Add your Pub/Sub logic here to retrieve processed messages
        messages = ["Pub/Sub Message A Processed", "Pub/Sub Message B Done"]
        return render(request, 'view.html', {'messages': messages})
    else:
        error_message = "Unsupported messaging type."
        return render(request, 'view.html', {'error': error_message})


def post_message(request):
    if request.method == 'POST':
        message = request.POST.get('message')
        if message:
            if settings.MESSAGING_TYPE == 'rabbitmq':
                #send_rabbitmq_message(message)
                print(f"Simulating sending '{message}' to rabbit")
                return redirect('index') # Redirect after successful post
            elif settings.MESSAGING_TYPE == 'pubsub':
                # Add your Pub/Sub logic here
                print(f"Simulating sending '{message}' to Pub/Sub")
                return redirect('index')
            else:
                error_message = "Unsupported messaging type."
                return render(request, 'post.html', {'error': error_message})
        else:
            error_message = "Please enter a message."
            return render(request, 'post.html', {'error': error_message})
    return render(request, 'post.html')

