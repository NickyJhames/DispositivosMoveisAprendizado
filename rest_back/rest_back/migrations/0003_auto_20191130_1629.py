# Generated by Django 2.2.6 on 2019-11-30 20:29

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('rest_back', '0002_auto_20191130_1537'),
    ]

    operations = [
        migrations.RenameField(
            model_name='promocat',
            old_name='cod_cat',
            new_name='idCat',
        ),
        migrations.RenameField(
            model_name='promocat',
            old_name='cod_prod',
            new_name='idProd',
        ),
        migrations.AddField(
            model_name='produto',
            name='idEmpresa',
            field=models.ForeignKey(default=None, on_delete=django.db.models.deletion.CASCADE, to='rest_back.Empresa'),
            preserve_default=False,
        ),
        migrations.AddField(
            model_name='produto',
            name='img',
            field=models.ImageField(default=None, upload_to='images/'),
            preserve_default=False,
        ),
    ]