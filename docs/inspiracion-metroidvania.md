# Adaptación de la guía de metroidvania

La guía compartida describe un género de acción y exploración 2D con mundo lateral, plataformas, cámara por sala, combate legible y progresión gradual. Esta entrega toma esos principios como referencia de estructura y los adapta a una aventura educativa original en Ciudad Nova. No reutiliza los personajes, nombres, mapas, arte ni historia de Hollow Knight.

## Decisiones incorporadas al prototipo

- **Movimiento:** aceleración y frenado, salto variable, coyote time, buffer breve del salto y gravedad mayor al caer para que el control sea tolerante y responsivo.
- **Lectura visual:** fondo en capas con contraste menor, plataformas con borde claro, estaciones luminosas y ecos morados con etiqueta para distinguir interactivos, suelo y peligro.
- **Cámara:** seguimiento horizontal acotado al nivel de una sala larga.
- **Encuentros:** ecos que patrullan con un patrón simple y legible; el pulso los dispersa y refuerza el tema de no amplificar rumores.
- **Exploración narrativa:** cuatro lugares cívicos ofrecen conversaciones cortas con una publicación, su fuente y decisiones concretas.
- **Datos visibles:** el árbol registra las rutas de decisión; BFS sobre el grafo social muestra el alcance potencial de compartir.
- **Alcance incremental:** una sala jugable y habilidades base primero. Dash, puertas de habilidad, guardado, mapa ampliado, audio y cooperativo quedan como siguientes etapas.

## Mecánicas de la referencia que quedan pendientes

El prototipo no incluye todavía doble salto, dash, salto de pared, jefes con fases, mapa persistente, guardado ni animación dibujada cuadro a cuadro. Se representan el personaje y los efectos mediante dibujo procedural de Pygame. Esas funciones requieren una fase posterior de contenido y ajuste; no se consideran entregadas por esta versión.

## Fuente

Guía completa para hacer un juego tipo Hollow Knight.pdf, proporcionada por el usuario, 83 páginas. Se revisó su texto completo. Se usaron especialmente las secciones sobre control del personaje (págs. 1–5 y 11–18), estructura de mundo y progresión (págs. 21–26), legibilidad visual y HUD (págs. 43–50 y 76–83), y flujo de producción incremental (págs. 7–10 y 57–65). Los consejos específicos de herramientas Godot/Krita se tomaron como referencia conceptual y no son dependencias del prototipo Python/Pygame.
