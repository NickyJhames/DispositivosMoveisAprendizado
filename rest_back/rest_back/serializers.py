from rest_framework import serializers
from .models import *


class EmpresaSerializer(serializers.ModelSerializer):

    class Meta:

        model = Empresa
        fields = '__all__'


class CategoriaSerializer(serializers.ModelSerializer):

    class Meta:

        model = Categoria
        fields = '__all__'


class ProdutoSerializer(serializers.ModelSerializer):

    class Meta:

        model = Produto
        fields = '__all__'


class PromocoesSerializer(serializers.ModelSerializer):

    class Meta:

        model = Promocoes
        fields = '__all__'
