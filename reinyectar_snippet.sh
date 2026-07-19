#!/bin/zsh
# Reinyecta el fallback de rutas SPA en app/index.html tras cada expo export
P=app/index.html
if ! grep -q "URLSearchParams" "$P"; then
  python3 -c "
s=open('$P').read()
snip='<script>(function(){var m=new URLSearchParams(location.search).get(\"p\");if(m){var rest=location.search.replace(/[?&]p=[^&]*/,\"\").replace(/^&/,\"?\");history.replaceState(null,\"\",location.pathname.replace(/\/\$/,\"\")+m+(rest||\"\"));}})();</script>'
open('$P','w').write(s.replace('</head>',snip+'</head>',1))
print('snippet reinyectado')
"
else echo "snippet ya presente"; fi
