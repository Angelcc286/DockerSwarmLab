# OPS-505 — Operación bajo restricciones

**Cliente:** NexaCloud · **Rol:** Platform Engineering · **Prioridad:** Alta · **Tiempo de implementación:** 120 minutos

## Historia de usuario

La plataforma se degrada cuando un contenedor consume recursos excesivos. SRE exige presupuestos de CPU/memoria y una política de reinicio verificable.

**Como** responsable de operaciones, **quiero** configurar reservas y límites de CPU/memoria, 2 réplicas, restart_policy y healthcheck. Obtener evidencia de inspect y de estado de tareas. **para** reducir riesgo operacional y poder explicar con evidencia que el comportamiento se cumple.

## Feature solicitada

Configurar reservas y límites de CPU/memoria, 2 réplicas, restart_policy y healthcheck. Obtener evidencia de inspect y de estado de tareas.

## Criterios de aceptación

1. La stack despliega con `docker stack deploy` en Swarm local de un nodo.
2. Se cumple cada propiedad declarada en [`team-05.json`](team-05.json); el contrato no debe modificarse.
3. Se ejecuta una prueba reproducible y se comparan resultados esperados y observados.
4. Se entrega `evidence.md` con decisiones, comandos, evidencia y límites.
5. Se entrega `presentation.md` y se expone en mesa redonda (máximo 10 minutos).
6. Se abre PR hacia `main` del docente y se revisan los checks.

## Pistas

Consultar documentación oficial de Docker sobre: deploy.resources; docker stats; docker service inspect; healthcheck. Buscar también `docker stack deploy` y `docker service inspect`. Empezar por una stack mínima y añadir propiedades una por una. **No asumir que `depends_on` ni `build` funcionan como en Docker Compose al desplegar stacks**.

## Preguntas para la mesa redonda

- ¿Qué incidente resolvieron y qué trade-offs asumieron?
- ¿Qué comando demuestra el resultado, en vez de solo mostrar YAML?
- ¿Qué limitación tiene su prueba en un único nodo?
- ¿Qué cambiarían para una instalación de producción?
