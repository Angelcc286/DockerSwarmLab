# SEC-303 — Credenciales protegidas

**Cliente:** NexaCloud · **Rol:** Platform Engineering · **Prioridad:** Alta · **Tiempo de implementación:** 120 minutos

## Historia de usuario

Una auditoría encontró contraseñas en variables de entorno y repositorios. El servicio de pagos debe recibir credenciales sin incluirlas en la imagen ni en Git.

**Como** responsable de operaciones, **quiero** crear un secreto externo local, referenciarlo como external en la stack, montarlo solo en el servicio autorizado y verificar lectura desde /run/secrets. **para** reducir riesgo operacional y poder explicar con evidencia que el comportamiento se cumple.

## Feature solicitada

Crear un secreto externo local, referenciarlo como external en la stack, montarlo solo en el servicio autorizado y verificar lectura desde /run/secrets.

## Criterios de aceptación

1. La stack despliega con `docker stack deploy` en Swarm local de un nodo.
2. Se cumple cada propiedad declarada en [`team-03.json`](team-03.json); el contrato no debe modificarse.
3. Se ejecuta una prueba reproducible y se comparan resultados esperados y observados.
4. Se entrega `evidence.md` con decisiones, comandos, evidencia y límites.
5. Se entrega `presentation.md` y se expone en mesa redonda (máximo 10 minutos).
6. Se abre PR hacia `main` del docente y se revisan los checks.

## Pistas

Consultar documentación oficial de Docker sobre: docker secret create; secrets external; /run/secrets; docker service inspect. Buscar también `docker stack deploy` y `docker service inspect`. Empezar por una stack mínima y añadir propiedades una por una. **No asumir que `depends_on` ni `build` funcionan como en Docker Compose al desplegar stacks**.

## Preguntas para la mesa redonda

- ¿Qué incidente resolvieron y qué trade-offs asumieron?
- ¿Qué comando demuestra el resultado, en vez de solo mostrar YAML?
- ¿Qué limitación tiene su prueba en un único nodo?
- ¿Qué cambiarían para una instalación de producción?
