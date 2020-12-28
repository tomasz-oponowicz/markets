project('com.bitstower.Markets', ['c', 'vala'],
          version: '0.4.0',
    meson_version: '>= 0.50.0',
  default_options: [ 'warning_level=2',
                   ],
)

app_binary = 'bitstower-markets'

app_id = meson.project_name() # com.bitstower.Markets
app_install_prefix = get_option('prefix')

add_project_arguments('-DGETTEXT_PACKAGE="@0@"'.format(app_id), language: 'c')

conf_data = configuration_data()
conf_data.set_quoted('APP_ID', app_id)
conf_data.set_quoted('APP_VERSION', meson.project_version())
conf_data.set_quoted('APP_INSTALL_PREFIX', app_install_prefix)
app_constants = configure_file(
    input : 'constants.vala.in',
    output : 'constants.vala',
    configuration : conf_data
)

i18n = import('i18n')
gnome = import('gnome')

subdir('data')
subdir('src')
subdir('po')

meson.add_install_script('build-aux/meson/postinstall.py')
