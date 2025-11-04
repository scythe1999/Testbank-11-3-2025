from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('criminology', '0001_initial'),
    ]

    operations = [
        migrations.RenameField(
            model_name='studentsscoreassessment',
            old_name='rank',
            new_name='rank_position',
        ),
        migrations.RenameField(
            model_name='studentsscoretos',
            old_name='rank',
            new_name='rank_position',
        ),
        migrations.RenameField(
            model_name='studentstop5',
            old_name='rank',
            new_name='rank_position',
        ),
    ]