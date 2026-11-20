# Alcalde Digital 3D

Prototipo educativo cooperativo en primera persona, desarrollado con Godot 4.7. Este es el proyecto activo del repositorio; el prototipo 2D en Python se conserva como antecedente en `src/`.

## Abrir y ejecutar

1. Instala Godot 4.7 o superior.
2. En el Project Manager, importa la carpeta `godot3d/` y abre `project.godot`.
3. Ejecuta el proyecto con F6 o F5. La escena principal configurada es `main.tscn`.

El renderer es Compatibility/OpenGL 3.3. La partida comienza en el menú; usa el mouse para elegir **JUGAR**, **TUTORIAL** o **AJUSTES**. Jugar abre la selección entre modo solitario y cooperativo.

## Controles

- Mouse: mirar.
- WASD o flechas: caminar.
- Espacio: saltar y hacer doble salto.
- E: interactuar con cofres, guardias y estaciones.
- Tab: cambiar el rol activo en solitario.
- 1, 2 y 3: responder a los minijuegos del Mensajero.
- Esc: liberar o capturar el cursor.

## Modos y objetivos

- **Solitario:** el jugador cambia entre los cuatro roles con Tab.
- **Cooperativo:** crea una sala o conéctate con un código. El anfitrión inicia la partida desde la sala.
- Los roles disponibles son Héroe (Ciudadano), Mensajero (Periodista), Bardo (Influencer) y Revolucionario (Candidato a alcalde). En una partida cooperativa no se asignan Periodista e Influencer a la misma persona.
- La partida tiene un límite de 10 minutos. El Héroe reúne y entrega hasta diez fichas; el Mensajero entrevista a los vecinos y resuelve un minipuzle por cada dato antes de aprobarlo o rechazarlo. El Bardo difunde solo los datos verdaderos aprobados, en un orden aleatorio de vecinos; los errores llevan a un final irregular. El Revolucionario mantiene alta la confianza.
- El primer distrito tiene cinco guardias con barra de ánimo. El ciclo de día y noche afecta el cielo y las luciérnagas.

La conexión cooperativa usa ENet por UDP en el puerto 7777. En una red local se puede conectar con el código generado; jugar por Internet puede requerir redirección del puerto en el router.

## Organización del proyecto

```text
godot3d/
├── project.godot                 configuración y escena inicial
├── main.tscn                     escena principal editable
├── alcalde_digital_3d.tscn       escena editable guardada desde Godot
├── scripts/
│   ├── world.gd                  mundo, zonas, colisiones, roles, menú e interfaz
│   ├── player.gd                 movimiento, salto y control de cámara
│   ├── role_manager.gd           distribución cooperativa de roles
│   └── dynamic_sky.gdshader      ciclo visual del cielo
└── assets/
    ├── kenney/                   modelos GLB, texturas y licencias
    ├── ui/                       fondo, placas, tutorial y tipografía
    └── audio/                    sonido de cofres
```

Godot genera `.godot/` al importar el proyecto; esa caché está excluida de Git. Las escenas se conservan en la raíz del proyecto para abrirlas y editarlas directamente.

## Créditos y licencias

Los modelos Kenney usados están bajo CC0. Revisa [activos y licencias](../docs/godot3d/activos-y-licencias.md). La tipografía Lilita One incluye su licencia OFL en `assets/ui/fonts/`.
