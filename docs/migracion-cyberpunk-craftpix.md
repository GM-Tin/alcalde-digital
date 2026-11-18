# Migración visual a CraftPix Cyberpunk

## Paquetes objetivo

- [Free Industrial Zone Tileset Pixel Art](https://craftpix.net/freebies/free-industrial-zone-tileset-pixel-art/): tiles de 32×32, fondo por capas de 576×324, objetos urbanos y mecanismos animados como trampas, puertas, pantallas y plataformas móviles.
- [Free 3 Cyberpunk Characters Pixel Art](https://craftpix.net/freebies/free-3-cyberpunk-characters-pixel-art/): tres personajes (hombre, mujer y cyborg), doce animaciones por personaje, hojas de 48 px de alto en PNG/PSD.

## Licencia y distribución

La licencia oficial de los freebies permite usarlos y modificarlos en proyectos personales y comerciales y distribuir juegos que los incluyan. No exige atribución, aunque la agradece. No permite redistribuir los archivos fuente de arte ni versiones modificadas que permitan extraerlos como recursos reutilizables. Por eso, los paquetes deben quedar en `assets/vendor/`, que ya está excluido de Git.

## Instalación local pendiente

CraftPix pide iniciar sesión para descargar estos archivos. Cuando estén disponibles, extraerlos así:

```text
assets/vendor/craftpix/industrial-zone/
assets/vendor/craftpix/cyberpunk-characters/
```

Luego se reemplazarán la escena mágica por una zona urbana industrial, las plataformas por los tiles del paquete y el protagonista por uno de los sprites animados. Se conservarán las tres secciones de mapa y la dinámica educativa; el fondo y el HUD adoptarán la paleta pixel art cyberpunk.
