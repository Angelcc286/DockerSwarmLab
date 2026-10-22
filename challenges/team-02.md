# REL-202 — Despliegues seguros

**Cliente:** NexaCloud · **Rol:** Platform Engineering · **Prioridad:** Alta · **Tiempo de implementación:** 120 minutos

## Historia de usuario

Un release defectuoso dejó el portal indisponible. El negocio exige despliegues progresivos con reversión controlada.

**Como** responsable de operaciones, **quiero** implementar 2 réplicas, update_config de una en una, monitor, failure_action rollback y rollback_config. Simular una imagen de actualización fallida. **para** reducir riesgo operacional y poder explicar con evidencia que el comportamiento se cumple.

## Feature solicitada

Implementar 2 réplicas, update_config de una en una, monitor, failure_action rollback y rollback_config. Simular una imagen de actualización fallida.

## Criterios de aceptación

1. La stack despliega con `docker stack deploy` en Swarm local de un nodo.
2. Se cumple cada propiedad declarada en [`team-02.json`](team-02.json); el contrato no debe modificarse.
3. Se ejecuta una prueba reproducible y se comparan resultados esperados y observados.
4. Se entrega `evidence.md` con decisiones, comandos, evidencia y límites.
5. Se entrega `presentation.md` y se expone en mesa redonda (máximo 10 minutos).
6. Se abre PR hacia `main` del docente y se revisan los checks.

## Pistas

Consultar documentación oficial de Docker sobre: docker service update; update_config; rollback_config; docker service inspect. Buscar también `docker stack deploy` y `docker service inspect`. Empezar por una stack mínima y añadir propiedades una por una. **No asumir que `depends_on` ni `build` funcionan como en Docker Compose al desplegar stacks**.

## Preguntas para la mesa redonda

- ¿Qué incidente resolvieron y qué trade-offs asumieron?
- ¿Qué comando demuestra el resultado, en vez de solo mostrar YAML?
- ¿Qué limitación tiene su prueba en un único nodo?
- ¿Qué cambiarían para una instalación de producción?
