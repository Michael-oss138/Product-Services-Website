from django.db import models
from django.utils.text import slugify
# Create your models here.

class ServiceCategory(models.Model):
    name = models.CharField(max_length=100, unique=True)
    slug = models.SlugField(max_length=100, unique=True, blank=True)
    description = models.TextField(blank=True, null=True)

    class Meta:
        verbose_name_plural = "Service Categories"
        ordering = ['name']

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        super().save(*args, **kwargs)

    def __str__(self):
        return self.name


class Service (models.Model):
    name = models.CharField(max_length=200)
    category = models.ForeignKey(
        ServiceCategory,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name= 'services'
    )
    description = models.TextField()
    price = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    is_active = models.BooleanField(default=True)
    image = models.ImageField(upload_to='service/', null=True, blank=True)
    created_at = models.DateField(auto_now_add=True)
    uploaded_at = models.DateField(auto_now=True)

    class Meta:
        ordering = ['-created_at']


    def __str__(self):
        return self.name

class CustomerServiceRequest(models.Model):
    customer_name = models.CharField(max_length=100)
    customer_email = models.EmailField()
    service = models.ForeignKey(
        Service,
        on_delete= models.CASCADE,
        related_name='requests'
    )
    details = models.TextField(help_text= "Please provide details relevant to your service request (e.g., NIN, existing SIM number, specific plan details).")

    STATUS_CHOICES = [
        ('pending', 'pending'),
        ('in_Progress', 'In Progress'),
        ('completed', 'Completed'),
        ('cancelled', 'Cancelled'),
    ]

    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')

    requested_at = models.DateField(auto_now_add=True)
    updated_at = models.DateField(auto_now=True)

    class Meta:
        ordering = ['-requested_at']

    def __str__(self):
        return f"Request for {self.service.name} by {self.customer_name} ({self.status})"
    
