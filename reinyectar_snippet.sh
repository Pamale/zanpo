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

# Fix scroll bloqueado al iniciar el gesto sobre una imagen o boton en web:
# react-native-web puede capturar el arrastre vertical dentro de elementos
# tactiles (TouchableOpacity) e imagenes, impidiendo que el navegador lo
# interprete como scroll de la pagina. touch-action:pan-y le dice al
# navegador que permita el scroll vertical nativo aunque el elemento
# tenga un manejador de toque/click.
if ! grep -q "touch-action" "$P"; then
  python3 -c "
s=open('$P').read()
css='<style>img,[role=\"button\"],[data-focusable=\"true\"]{touch-action:pan-y;}</style>'
open('$P','w').write(s.replace('</head>',css+'</head>',1))
print('fix scroll (touch-action) reinyectado')
"
else echo "fix scroll ya presente"; fi
