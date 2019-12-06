from django import forms
from .models import Produto, Empresa, Promocoes

class ProdutoForm(forms.ModelForm):

    class Meta:
        model = Produto
        fields = "__all__"


class EmpresaForm(forms.ModelForm):

    class Meta:
        model = Empresa
        fields = "__all__"


class PromocoesForm(forms.ModelForm):

    class Meta:
        model = Promocoes
        fields = "__all__"

