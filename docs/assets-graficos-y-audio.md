# Recursos gráficos y de audio

## Integrados en el juego

- El jugador usa animaciones idle, caminar y salto de **BlueWizard Animations**, del paquete **Mossy Cavern**, del autor Maaot.
- Los enemigos pequeños usan los cuadros animados de **Slimes** del mismo paquete.
- Las plantas animadas de **Plant Animations** decoran el recorrido y el guardián final usa la hoja de animación idle de **Dark Fantasy Big Boss 1**, de zneeke.
- La música en bucle **Moist Walls** de drmseq suena como ambiente. Su licencia permite usarla y distribuirla dentro de un proyecto terminado; el crédito es opcional. Se conserva la licencia original en `assets/audio/LICENSE-Erased-Places.txt`.

## Recursos externos y licencias

Los paquetes originales completos están en `assets/vendor/`, excluidos de Git porque sus licencias no permiten redistribuirlos como paquetes o archivos sueltos. Para obtenerlos:

1. **Mossy Cavern**, Maaot: [página del paquete](https://maaot.itch.io/mossy-cavern). La licencia permite el uso comercial y la modificación; prohíbe revender o redistribuir el arte, incluso dentro de otro paquete de recursos. Descarga el paquete y extrae `BlueWizard Animations`, `Plant Animations` y `Slimes` en `assets/vendor/mossy-cavern/`.
2. **Dark Fantasy Big Boss 1**, zneeke: [descarga gratuita](https://zneeke.itch.io/dark-fantasy-big-boss-1). La versión gratuita admite uso comercial y modificaciones, pero no la reventa ni redistribución del paquete o sus recursos. Extrae el contenido en `assets/vendor/zneeke-boss/Free Boss/`.

Los paquetes completos no son necesarios para iniciar el juego: si faltan, se usa el personaje y los enemigos vectoriales originales, además de plataformas y decoración dibujadas por el juego. La pista ambiental sí se incluye en `assets/audio/` conforme a la licencia del autor.

## Créditos

- Arte: Maaot, **Mossy Cavern**; zneeke, **Dark Fantasy Big Boss 1**.
- Música: drmseq, **Erased Places — Moist Walls**.
