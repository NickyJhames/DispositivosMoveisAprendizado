from django.db import models

# Create your models here.
from pygments.styles import default


class Empresa(models.Model):

    class Meta:

        db_table = 'empresa'

    nome = models.CharField(max_length=100)
    endereco = models.CharField(max_length=80)
    telefone = models.CharField(max_length=18)
    email = models.CharField(max_length=50)
    imagem = models.ImageField(upload_to='images/empresa/')

    def __str__(self):
        return self.nome


class Categoria(models.Model):

    class Meta:

        db_table = 'categoria'

    tipo = models.CharField(max_length=40)

    def __str__(self):
        return self.tipo


class Produto(models.Model):

    class Meta:

        db_table = 'produto'

    nome = models.CharField(max_length=40)
    valor = models.FloatField(max_length=10)
    img = models.ImageField(upload_to='images/produto/')
    idEmpresa = models.ForeignKey(Empresa, on_delete=models.CASCADE)
    idCategoria = models.ForeignKey(Categoria, on_delete=models.CASCADE)

    def __str__(self):
        return self.nome


class Promocoes(models.Model):

    class Meta:

        db_table = 'promocoes'

    texto = models.TextField(max_length=300)
    desconto = models.IntegerField(max_length=3)
    desc_pagamento = models.IntegerField(max_length=1)
    relevancia = models.IntegerField(max_length=1)
    produto = models.ForeignKey(Produto, on_delete=models.CASCADE)
    idEmpresa = models.ForeignKey(Empresa, on_delete=models.CASCADE)
    dataInicial = models.DateTimeField(blank=False)
    dataFinal = models.DateTimeField(blank=False)

    def __str__(self):
        return self.texto


class Promocat(models.Model):

    class Meta:

        db_table = 'promocat'

    idProd = models.ForeignKey(Produto, on_delete=models.CASCADE)
    idCat = models.ForeignKey(Categoria, on_delete=models.CASCADE)
