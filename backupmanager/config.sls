{% from "backupmanager/map.jinja" import map with context %}

{% set template_file = salt['pillar.get']('backupmanager:lookup:template_file', 'salt://backupmanager/files/backup-manager.conf') %}

{{ map.get('conf-file') }}:
  file.managed:
    - user:     {{ map.get('user', 'root') }}
    - group:    {{ map.get('group', 'root') }}
    - mode:     440
    - template: jinja
    - source:   {{ template_file }}
    - context:
        included: False


{% if salt['pillar.get']('backupmanager:mysql:adminpass') %}
/root/.backup-manager_my.cnf:
  file.managed:
    - source: salt://backupmanager/files/.backup-manager_my.cnf
    - mode: 600
    - template: jinja
{% endif %}


{% if salt['pillar.get']('backupmanager:pgsql:adminpass') %}
/root/.pgpass:
  file.managed:
    - source: salt://backupmanager/files/.pgpass
    - mode: 600
    - template: jinja
{% endif %}

# {% if salt['pillar.get']('backupmanager:upload:ssh:hosts') %}
# {% for hostitem in salt['pillar.get']('backupmanager:upload:ssh:hosts', []) %}
# {{ hostitem }}:
#   ssh_known_hosts:
#     - present
#     - user: root
# {% endfor %}
# {% endif %}


{% if salt['pillar.get']('backupmanager:upload:ssh:hosts') %}
{{ salt['pillar.get']('backupmanager:upload:ssh:hosts') }}:
  ssh_known_hosts:
    - present
    - user: root
{% endif %}
