from django.contrib.auth import authenticate, models
from django.contrib.auth.models import User
from django.views.decorators.csrf import csrf_exempt
from rest_framework.authtoken.models import Token
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.status import (
    HTTP_400_BAD_REQUEST,
    HTTP_404_NOT_FOUND,
    HTTP_200_OK,
    HTTP_201_CREATED
)
from rest_framework.response import Response
from .models import *
from .serializers import *
from django.views.generic import ListView,CreateView
from .forms import ProdutoForm, EmpresaForm, PromocoesForm

###HTML
class CreateProdutoView(CreateView): # new
    model = Produto
    form_class = ProdutoForm
    template_name = 'produto.html'

class CreateEmpresaView(CreateView): # new
    model = Empresa
    form_class = EmpresaForm
    template_name = 'empresa.html'


class CreatePromocoesView(CreateView): # new
    model = Promocoes
    form_class = PromocoesForm
    template_name = 'promocoes.html'


###REST

@csrf_exempt
@api_view(["POST"])
@permission_classes((AllowAny,))
def login(request):
    username = request.data.get("username")
    password = request.data.get("password")
    if username is None or password is None:
        return Response({'error': 'Por favor informe usuario e senha'},
                        status=HTTP_400_BAD_REQUEST)
    user = authenticate(username=username, password=password)
    if not user:
        return Response({'error': 'Credenciais Invalidas'},
                        status=HTTP_404_NOT_FOUND)
    token, _ = Token.objects.get_or_create(user=user)
    return Response({'token': token.key},
                    status=HTTP_200_OK)


@csrf_exempt
@api_view(["POST"])
@permission_classes((AllowAny,))
def cria_usuario(request):
    username = request.data.get("username")
    password = request.data.get("password")
    email = request.data.get("email")

    if username is None or password is None or email is None:
        return Response({'error': 'Por favor informe usuario e senha'},
                        status=HTTP_400_BAD_REQUEST)
    user = User.objects.create_user(
        username=username,
        email=email,
        password=password
    )

    if not user:
        return Response({'error': 'Credenciais Invalidas'},
                        status=HTTP_404_NOT_FOUND)

    token, _ = Token.objects.get_or_create(user=user)
    return Response({'token': token.key},
                    status=HTTP_200_OK)


@csrf_exempt
@api_view(["GET","POST"])
def view_categoria(request):
    if request.method == 'GET':
        snippets = Categoria.objects.all()
        serializer = CategoriaSerializer(snippets, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = CategoriaSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=HTTP_201_CREATED)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)


@csrf_exempt
@api_view(["GET","POST"])
def view_empresa(request):
    if request.method == 'GET':
        snippets = Empresa.objects.all()
        serializer = EmpresaSerializer(snippets, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = EmpresaSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=HTTP_201_CREATED)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)


@csrf_exempt
@api_view(["GET","POST"])
def view_produto(request):
    if request.method == 'GET':
        snippets = Produto.objects.all()
        serializer = ProdutoSerializer(snippets, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = ProdutoSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=HTTP_201_CREATED)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)

@csrf_exempt
@api_view(["GET", "POST"])
def view_promocoes(request):
    if request.method == 'GET':
        snippets = Promocoes.objects.all()
        serializer = PromocoesSerializer(snippets, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = PromocoesSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=HTTP_201_CREATED)
        return Response(serializer.errors, status=HTTP_400_BAD_REQUEST)