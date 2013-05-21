name                  'proxy'
description           'Sets up instances for proxying traffic'
maintainer            'Simple Finance'
maintainer_email      'ops@simple.com'
license               'Apache 2.0'
version               '1.2.0'

depends 'haproxy'

# Necessary for the `monitoring` recipe
suggests 'sensu'

