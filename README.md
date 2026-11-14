# Alcalde Digital

Videojuego educativo 2D en Python sobre el uso responsable de redes sociales durante una elección local. Es una aventura lateral cartoon de tres zonas: recorre el bosque, el distrito de cristal y el observatorio celeste; salta por plataformas de estilos distintos, dispersa ecos de rumores y resuelve retos de los cristales para recuperar publicaciones.

## Ejecutar

Requiere Python 3.10 o superior y Pygame:

```bash
python -m pip install -r requirements.txt
python -m src.main
```

## Controles

- `A/D` o flechas: caminar.
- `Espacio`: saltar (salto variable y margen de coyote).
- `X` o `J`: pulso para dispersar ecos de rumores.
- `E`: conversar en una estación iluminada.
- En conversación: `V` verificar, `C` compartir, `R` reportar, `I` ignorar.
- `M`: mapa; `H`: ayuda; `ESC`: cerrar panel o salir.

Las publicaciones aparecen con un reto breve. Decidir cambia el estado de la ciudad y la confianza de sus habitantes; el grafo social calcula cuántos ciudadanos reciben un contenido compartido. La barra espaciadora permite continuar tras el resumen de una ronda.

## Alcance de esta entrega

Incluye movimiento lateral con aceleración, salto variable, gravedad de caída más fuerte, coyote time, cámara que recorre el mundo, seis retos de cristal (operaciones, reconocimiento de fuentes y tres en raya), vida, enemigos con patrulla y daño, guardián final, ataque corto, mapa, publicaciones verdaderas/falsas, árbol de decisiones y grafo social BFS para enseñar el alcance potencial de compartir. Guardado, cooperativo local y ajustes adicionales de accesibilidad quedan para siguientes incrementos.

La entrega también usa animaciones cartoon de personaje y criaturas, un guardián final, vegetación animada y música ambiental en bucle. La música está incluida; los paquetes externos de arte se excluyen de Git por sus condiciones de redistribución. Consulta [`docs/assets-graficos-y-audio.md`](docs/assets-graficos-y-audio.md) para créditos, licencias e instalación local.

## Organización

- `src/main.py`: arranque y ciclo principal.
- `src/game.py`: aventura lateral, cámara, plataformas, interfaz, combate ligero y conversaciones.
- `src/models.py`: árbol de decisiones, publicaciones, ciudad y grafo social.
- `docs/`: lectura de requisitos y análisis de patrones interactivos.
- `docs/plan.md`: entregas y trabajo pendiente.

## Estructuras de datos

El árbol binario `DecisionNode` representa las decisiones (verificar → compartir/reportar; también ignorar); `DecisionTree.traverse` registra el recorrido elegido. El grafo no dirigido `SocialGraph` representa las relaciones ciudadanas; `reachable_from` usa BFS para calcular alcance sin visitar dos veces una persona. El registro de cada ronda conserva la publicación y las acciones para poder explicar su impacto.

## Git

El repositorio remoto privado es [GM-Tin/alcalde-digital](https://github.com/GM-Tin/alcalde-digital). Cada integrante debe trabajar en una rama o módulo identificable y registrar commits propios, tal como pide el laboratorio.

## Investigación y requisitos

Ver [`docs/requisitos-y-lectura.md`](docs/requisitos-y-lectura.md), [`docs/investigacion-playables.md`](docs/investigacion-playables.md) y [`docs/plan.md`](docs/plan.md).
