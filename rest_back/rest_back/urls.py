"""rest_back URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from .views import login, cria_usuario
from django.urls import path, include
from . import settings
from django.contrib.staticfiles.urls import static
from django.contrib.staticfiles.urls import staticfiles_urlpatterns
from .views import view_categoria, view_empresa, view_produto,view_promocoes,\
    CreateProdutoView,CreateEmpresaView, CreatePromocoesView



urlpatterns = [
    path('admin/', admin.site.urls),
    path('accounts/', include('django.contrib.auth.urls')),  # new

    path('rest/login', login),
    path('rest/cria_usuario', cria_usuario),
    path('rest/view_categoria',view_categoria),
    path('rest/view_empresa',view_empresa),
    path('rest/view_produto',view_produto),
    path('rest/view_promocoes',view_promocoes),

    path('cadastra_produto/', CreateProdutoView.as_view(), name='add_produto'),
    path('cadastra_empresa/', CreateEmpresaView.as_view(), name='add_empresa'),
    path('cadastra_promocoes/', CreatePromocoesView.as_view(), name='add_promocoes'),

]

urlpatterns += staticfiles_urlpatterns()
urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
