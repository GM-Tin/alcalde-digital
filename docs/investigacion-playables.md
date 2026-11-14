# Investigación: estructura de experiencias jugables cortas

**Alcance.** No existe un catálogo estable que permita enumerar “todos” los juegos y anuncios jugables: las campañas cambian, no todas se archivan y cada red acepta formatos diferentes. Esta revisión resume formatos y ejemplos documentados por fuentes primarias, y extrae patrones aplicables a Alcalde Digital. No supone que estos productos sean todos exclusivamente infantiles.

## Qué es un playable ad

Unity describe un playable como una experiencia interactiva corta que da una impresión del juego o app, ejecutada en una vista web publicitaria; puede aparecer sola o como tarjeta interactiva tras un video. Su formato debe adaptarse a orientación y controles móviles, y el contenido debe respetar zonas reservadas para controles de la red. La conversión a tienda, cuando existe, debe ser consecuencia de una acción explícita del jugador, no un toque accidental.

## Formatos y mecánicas observadas

| Formato | Interacción central | Estructura frecuente | Adaptación al proyecto |
|---|---|---|---|
| Tutorial “tap to engage” | Tocar puntos u objetos resaltados | Gancho/guía → 1–10 interacciones → tarjeta final | Dar una acción inicial evidente: caminar hasta una publicación y verificarla |
| Tap-to-reveal | Tocar para descubrir contenido | Curiosidad visual → revelar → resultado | Revelar fuente, contexto o señales de edición de una noticia |
| Tap-to-swipe | Deslizar, sobre todo en experiencias móviles | Instrucción gestual → elección/desplazamiento → cierre | Mover personaje o contenido con teclado y, posteriormente, toque/gesto |
| Choose-the-result | Seleccionar una de varias opciones | Decisión breve → consecuencia inmediata → cierre | Elegir verificar, compartir, reportar o ignorar y ver el efecto social |
| Choose-and-reveal | Escoger antes de mostrar desenlace | Opciones → revelación → feedback | Mostrar cómo cambian confianza, convivencia y alcance según la decisión |
| End card interactiva | Interactuar tras un anuncio en video | Video → interacción corta → tarjeta de salida | No se adopta como publicidad; el patrón de cierre puede inspirar resumen de partida |

Unity Playworks documenta plantillas de “tap to engage”, “tap to reveal”, “tap to swipe”, “choose the result” y “choose and reveal”. La plantilla de tap-to-engage puede incluir video, entre uno y diez puntos interactivos, pistas, un puntero opcional, banner, sonido y tarjeta final. Para este proyecto tomamos solo onboarding conciso, pistas y bucle de acción-feedback.

## Estructura de interacción útil

1. **Arranque rápido:** escena y objetivo legibles sin tutorial extenso.
2. **Pista de primera acción:** resaltar una publicación o mostrar una indicación breve.
3. **Una mecánica principal:** interactuar con contenido, comprobar su fuente y tomar una decisión.
4. **Feedback causal:** respuesta visual inmediata y cambio visible en alcance e indicadores.
5. **Cierre con consecuencia:** resumen corto de la ronda que invite a continuar.

Este flujo se observa de manera explícita en recomendaciones de Unity: la experiencia debe orientar rápidamente, mostrar interacción clara y finalizar con tarjeta de cierre cuando es un anuncio. **Inferencia de diseño:** el mismo orden sirve para el juego educativo, pero la tarjeta comercial se reemplaza por un resumen pedagógico de resultados.

## Decisión de cámara y control

Se recomienda una **vista 2D cenital fija** para Ciudad Nova: evita mareo, mantiene personaje, lugares y red social dentro del mismo encuadre, y da un control estable para una demo corta. El juego usa WASD/flechas y un movimiento animado simple; las decisiones también tienen atajos de teclado con rótulos. Más adelante la misma escena puede sumar soporte táctil. Esto adopta el principio de interacción clara y adaptable de los playables sin tratar de simular una campaña publicitaria.

## Diseño responsable para público joven

La FTC advierte sobre publicidad encubierta en contenidos digitales dirigidos a niños y propone señales claras que permitan reconocer los mensajes publicitarios. Por eso esta adaptación es una experiencia educativa y no un advergame de marca: no inserta producto, CTA de compra, enlaces comerciales, anuncios reales, perfilado ni recolección de datos. Si el proyecto se publica algún día, habría que revisar las reglas vigentes del territorio y plataforma correspondientes.

## Fuentes primarias

- Unity, [Playable specifications](https://docs.unity.com/en-us/user-acquisition/creatives/specifications/playable): formato, responsive, viewability y requisitos técnicos.
- Unity, [How to create playable ads with Unity Playworks](https://unity.com/resources/how-to-create-playable-ads): descripción de plantillas, guía, interacciones y end cards.
- Unity, [Playable best practices](https://docs.unity.com/en-us/user-acquisition/creatives/best-practices/playable): orientación y presentación del playable.
- FTC, [Protecting Kids from Stealth Advertising in Digital Media](https://www.ftc.gov/system/files/ftc_gov/pdf/p214505kidsadvertisingstaffperspective092023.pdf): recomendaciones para que niños reconozcan publicidad digital.
