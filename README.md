# Alcalde Digital

Videojuego educativo 2D en Python sobre el uso responsable de redes sociales durante una elección local. Esta es la primera entrega jugable, preparada para crecer por módulos y recibir contribuciones por Git.

## Ejecutar

Requiere Python 3.10 o superior y Pygame:

```bash
python -m pip install -r requirements.txt
python -m src.main
```

## Controles

- `WASD` o flechas: mover al personaje por Ciudad Nova.
- `Q`: verificar la publicación activa.
- `C`: compartirla (solo tras verificarla).
- `R`: reportarla.
- `I`: ignorarla.
- `H`: ayuda; `ESC`: salir.

Las publicaciones aparecen con un reto breve. Decidir cambia el estado de la ciudad y la confianza de sus habitantes; el grafo social calcula cuántos ciudadanos reciben un contenido compartido. La barra espaciadora permite continuar tras el resumen de una ronda.

## Alcance de esta entrega

Incluye una escena cartoon, movimiento animado, ciclo de decisiones, publicaciones verdaderas/falsas, un árbol de decisión explícito, grafo social con recorrido BFS, difusión, eventos aleatorios, indicadores y ayuda integrada. El multijugador local cliente-servidor, los cuatro roles, la elección final, más escenas y opciones de accesibilidad están previstos como siguientes incrementos; no se presentan como funciones ya terminadas.

## Organización

- `src/main.py`: arranque y ciclo principal.
- `src/game.py`: interfaz, movimiento, animación y reglas del turno.
- `src/models.py`: árbol de decisiones, publicaciones, ciudad y grafo social.
- `docs/`: lectura de requisitos y análisis de patrones interactivos.
- `docs/plan.md`: entregas y trabajo pendiente.

## Estructuras de datos

El árbol binario `DecisionNode` representa las decisiones (verificar → compartir/reportar; también ignorar); `DecisionTree.traverse` registra el recorrido elegido. El grafo no dirigido `SocialGraph` representa las relaciones ciudadanas; `reachable_from` usa BFS para calcular alcance sin visitar dos veces una persona. El registro de cada ronda conserva la publicación y las acciones para poder explicar su impacto.

## Git

El repositorio remoto privado es [GM-Tin/alcalde-digital](https://github.com/GM-Tin/alcalde-digital). La primera publicación web incluyó este README, `requirements.txt` y `.gitignore`; los módulos del juego y la documentación siguen en el checkout local hasta completar la sincronización. Cada integrante debe trabajar en una rama o módulo identificable y registrar commits propios, tal como pide el laboratorio.

## Investigación y requisitos

Ver [`docs/requisitos-y-lectura.md`](docs/requisitos-y-lectura.md), [`docs/investigacion-playables.md`](docs/investigacion-playables.md) y [`docs/plan.md`](docs/plan.md).
