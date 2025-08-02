from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.contrib import messages
from django.contrib.auth.models import User,auth

 Create your views here.
def home(request):
    return render(request, 'core/home.html')

def products(request):
    return render(request, 'core/products.html')

def services(request):
    return render(request, 'core/services.html')
#
def register(request):
    if request.method == 'POST':
        username = request.POST['username']
        email = request.POST['email']
        password = request.POST['password']
        password = request.POST['password2']


        if password == password2:
            if User.objects.filter(username=username).exists():
                message.info(request, 'Username already used')
                return redirect('register')

            elif User.objects.filter(email=email).exists():
                message.info(request, 'Email already used')
                return redirect('register')

            else:
                User.Objects.create(usernamae=username, email=email, password=password)
                user.save()
                return redirect('login')

        else:
            message.info(request, 'Password not the same')
            return redirect('register')

    else:
        return render(request, 'core/register.html',{'title': 'Register To Get Started'})
