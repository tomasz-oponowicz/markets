project('markets', ['c', 'vala'], 
          version: '0.1.0',
    meson_version: '>= 0.50.0',
  default_options: [ 'warning_level=2',
                   ],
)

app_prefix = get_option('prefix')
app_datadir = join_paths(app_prefix, get_option('datadir'))
app_id = 'com.bitstower.Markets'

i18n = import('i18n')
gnome = import('gnome')

subdir('data')
subdir('src')
subdir('po')

meson.add_install_script('build-aux/meson/postinstall.py')
