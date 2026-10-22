# SwarmOps Challenge | NexaCloud

## Historia de la empresa

NexaCloud es una empresa ficticia de servicios digitales que opera APIs y componentes internos. Tras varios incidentes (caídas, releases defectuosos, exposición de secretos, redes abiertas y consumo excesivo de recursos), la dirección de ingeniería abre un sprint de estabilización. Cada equipo asume el rol de una célula de Platform Engineering y recibe un ticket de producción. **No se desarrolla código de negocio**: se diseña, configura, opera y verifica infraestructura de contenedores.

## Objetivos de aprendizaje

- Diferenciar orquestación de simple ejecución de contenedores.
- Utilizar `docker stack deploy`, servicios, tareas, redes, secretos y políticas de despliegue.
- Argumentar decisiones de disponibilidad, seguridad y operación.
- Entregar cambios mediante fork, branch y Pull Request con verificación automatizada.
- Demostrar funcionalidad con evidencias reproducibles y presentar resultados técnicos.

## Requisitos previos

Docker Engine/Desktop con Swarm habilitable, Git, cuenta GitHub, terminal y acceso a Internet para obtener imágenes oficiales (`nginx:1.27-alpine`, `busybox:1.36`, `traefik/whoami:v1.11`). No se requiere programar Python. Usar terminal Bash o adaptar comandos en PowerShell. **No publicar secretos reales**.

## Reglas de trabajo

Cada equipo edita únicamente `submissions/team-XX/docker-stack.yml`, `submissions/team-XX/evidence.md` y `submissions/team-XX/presentation.md`. La carpeta `challenges/` contiene contratos de evaluación de solo lectura.

## Misiones

| Equipo | Ticket  | Feature                 | Contrato                           |
| ------ | ------- | ----------------------- | ---------------------------------- |
| 01     | INC-101 | Resiliencia ante fallos | [Misión 01](challenges/team-01.md) |
| 02     | REL-202 | Despliegues seguros     | [Misión 02](challenges/team-02.md) |
| 03     | SEC-303 | Gestión de secretos     | [Misión 03](challenges/team-03.md) |
| 04     | NET-404 | Redes privadas y DNS    | [Misión 04](challenges/team-04.md) |
| 05     | OPS-505 | Recursos y operación    | [Misión 05](challenges/team-05.md) |

## Cronograma de implementación (120 min)

| Tiempo      | Actividad                                                                 |
| ----------- | ------------------------------------------------------------------------- |
| 0–15 min    | Leer incidente, criterios de aceptación y hacer fork.                     |
| 15–35 min   | Diseñar topología y decisiones en `evidence.md`.                          |
| 35–80 min   | Configurar stack, desplegar y depurar.                                    |
| 80–100 min  | Ejecutar experimento de fallo/seguridad/operación y registrar evidencias. |
| 100–115 min | Preparar presentación corta y documentación.                              |
| 115–120 min | Commit, push, Pull Request y verificar checks.                            |

## Flujo de GitHub: fork → branch → PR

1. Abrir el repositorio público del docente en GitHub y pulsar **Fork** → **Create fork** en la cuenta de un integrante.
2. Clonar el fork: `git clone https://github.com/TU_USUARIO/swarmops-challenge.git` y entrar con `cd swarmops-challenge`.
3. Crear rama: `git switch -c feature/team-01-resilience` (ajustar equipo).
4. Leer `challenges/team-01.md` y `challenges/team-01.json`.
5. Editar exclusivamente los tres archivos de `submissions/team-01/`.
6. Validar localmente: `docker swarm init` (solo si no está activo); `docker stack deploy -c submissions/team-01/docker-stack.yml team01`; `docker stack services team01`; `docker stack ps team01`.
7. Para correr tests locales: `python -m pip install -r requirements.txt` y `python -m pytest -q tests/test_contracts.py --team team-01`. Las pruebas locales estáticas no sustituyen la evidencia de ejecución.
8. Documentar comandos, resultados observados, decisiones, límites y evidencia en `evidence.md`. Preparar guion de presentación en `presentation.md`.
9. Ejecutar `git add submissions/team-01/ && git commit -m "feat(team-01): resilience mission" && git push -u origin feature/team-01-resilience`.
10. En GitHub del fork pulsar **Contribute → Open pull request**. Verificar **base repository: repositorio del docente**, **base: main**, **head: fork / feature/team-01-resilience**.
11. Título obligatorio: `[TEAM-01] INC-101 - Resiliencia ante fallos`. Completar plantilla de PR; abrirlo y consultar pestaña **Checks**. Corregir errores en la misma rama y hacer push: el PR se actualiza automáticamente.
    > **Nota :bulb:**
    > **No hacer merge**. El docente revisa, ejecuta/autoriza las verificaciones y decide cierre o merge.

## Entregables obligatorios

1. `docker-stack.yml`: solución declarativa válida y desplegable.
2. `evidence.md`: diseño, comandos exactos, capturas o salidas anonimizadas, experimento ejecutado, resultados esperados/observados y limitaciones.
3. `presentation.md`: guion de hasta 10 minutos con problema, arquitectura, demo, validaciones, decisiones y aprendizajes. En la mesa redonda puede usarse este archivo o diapositivas adicionales (no obligatorias).
4. PR al `main` del docente con checks visibles. **El PR no es evidencia suficiente sin ejecución local y explicación técnica.**

## Rúbrica (100 puntos)

| Criterio                              |  Puntos | Evaluación                      |
| ------------------------------------- | ------: | ------------------------------- |
| Estructura y contrato YAML            |      15 | Automática estática             |
| Configuración técnica específica      |      20 | Automática estática             |
| Despliegue y estado de servicio       |      15 | Automática en Swarm             |
| Prueba de comportamiento de la misión |      20 | Automática en Swarm + evidencia |
| Evidencias y razonamiento técnico     |      10 | Docente                         |
| Presentación (≤10 min) y preguntas    |      15 | Docente                         |
| Flujo Git / PR y colaboración         |       5 | Docente                         |
| **Total**                             | **100** |                                 |

## Comandos útiles

```bash
docker info --format '{{.Swarm.LocalNodeState}}'
docker swarm init
docker stack deploy -c submissions/team-01/docker-stack.yml team01
docker stack services team01
docker stack ps team01
docker service ls
docker service ps team01_api --no-trunc
docker service inspect team01_api --pretty
docker stack rm team01
```
