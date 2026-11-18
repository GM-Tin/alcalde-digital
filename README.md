# Alcalde Digital

Juego educativo sobre desinformación y participación ciudadana. El proyecto activo es una aventura 3D en primera persona hecha en Godot. El prototipo lateral en Python/Pygame permanece en `src/` como antecedente.

## Proyecto 3D (activo)

Abre `godot3d/project.godot` en Godot 4.7 o superior y ejecuta con F5. El juego empieza en un menú con **JUGAR**, **TUTORIAL** y **AJUSTES**. Desde Jugar se elige el modo solitario o cooperativo.

- `WASD` / flechas: caminar.
- Mouse: mirar.
- Espacio: saltar y doble salto.
- `E`: interactuar.
- `Tab`: cambiar de rol en solitario.
- `1`, `2`, `3`: resolver respuestas del Mensajero.
- `Esc`: liberar o capturar el cursor.

El mapa reúne tres zonas conectadas (mazmorra, arena y arcade), objetos con colisiones, cofres informativos y cinco guardias en el primer distrito. La partida dura diez minutos e incluye roles, ciclo de día y noche, luciérnagas y actividades para recoger, comprobar y compartir información. El modo cooperativo usa ENet/UDP 7777; para jugar por Internet puede requerirse abrir ese puerto.

Consulta la [guía del proyecto 3D](godot3d/README.md) y la documentación de [activos y licencias](docs/godot3d/activos-y-licencias.md).

## Prototipo 2D (Python/Pygame)

El prototipo anterior se ejecuta con Python 3.10 o superior:

```bash
python -m pip install -r requirements.txt
python -m src.main
```

Sus documentos de requisitos, investigación y arte se conservan como referencia independiente en `docs/`.

## Estructura

```text
.
├── godot3d/             proyecto activo de Godot
├── src/                 prototipo anterior en Python/Pygame
├── docs/godot3d/        arquitectura, licencias y créditos 3D
├── docs/                documentación histórica y de diseño
└── requirements.txt     dependencias del prototipo Python
```

## Requisitos y contexto

Consulta `docs/requisitos-y-lectura.md`, `docs/investigacion-playables.md` y `docs/plan.md` para los documentos originales del laboratorio.
