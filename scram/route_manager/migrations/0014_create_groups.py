# Generated by Django 3.1.7 on 2021-10-28 17:50

from django.core.management.sql import emit_post_migrate_signal
from django.db import migrations


def create_groups(apps, schema_editor):
    db_alias = schema_editor.connection.alias
    emit_post_migrate_signal(2, False, db_alias)

    Group = apps.get_model('auth', 'Group')
    Permission = apps.get_model('auth', 'Permission')

    view_entry = Permission.objects.get(name="Can view entry")
    view_history = Permission.objects.get(name="Can view history")
    view_route = Permission.objects.get(name="Can view route")

    read_perms = [view_entry, view_history, view_route]

    add_entry = Permission.objects.get(name="Can add entry")
    add_history = Permission.objects.get(name="Can add history")
    add_route = Permission.objects.get(name="Can add route")
    change_history = Permission.objects.get(name="Can change history")

    write_perms = [add_entry, add_history, add_route, change_history]

    ro = Group(name="readonly")
    ro.save()
    ro.permissions.set(read_perms)
    ro.save()

    rw = Group(name="readwrite")
    rw.save()
    rw.permissions.set(read_perms + write_perms)
    rw.save()

class Migration(migrations.Migration):

    dependencies = [
        ('contenttypes', '__latest__'),
        ('sites', '__latest__'),
        ('route_manager', '0013_accept_cidrs'),
    ]

    operations = [
        migrations.RunPython(create_groups)
    ]
