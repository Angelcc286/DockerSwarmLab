# Evidencias — team-03

## Diseño propuesto
<!-- Arquitectura y decisiones -->
Se agrega "Command" debido a que se necesita para que el servicio tenga una acción a realizar.
Añadimos el servicio secreto en base a la documentación oficial de Docker Swarm y se agrega también dentro del archivo `docker-stack.yml` con la propiedad `external: true` para evitar exponer la contraseña en el código fuente.

## Comandos de despliegue
```bash
echo 'training-only-token' | docker secret create demo_token -  # Crear el secreto

docker stack deploy -c docker-stack.yml team03 # Desplegar stack

docker stack services team03 # Verificar estado
docker stack ps team03 # Verificar estado
docker service logs team03_vault_client # Verificar logs del servicio, debe arrojar "secret-mounted"
```

## Experimento funcional
**Hipótesis:**
Se espera que el servicio se despliegue correctamente y que el secreto sea montado en el servicio.

**Procedimiento:**
```bash
echo 'training-only-token' | docker secret create demo_token -  # Crear el secreto

docker stack deploy -c docker-stack.yml team03 # Desplegar stack

docker stack services team03 # Verificar estado
docker stack ps team03 # Verificar estado
docker service logs team03_vault_client # Verificar logs del servicio

python -m pip install -r requirements.txt # Instalamos dependencias (En mi caso ya tenia la libreria PyYAML con una version mas actualizada)

python -m pytest -q tests/test_contracts.py --team team-03 # Ejecutamos pruebas unitarias
```

**Resultado esperado:**
Se necesita que apruebe todas las pruebas unitarias aparte de eso, la contraseña o "secret" no debe ser visible en el github, ni configuracion del yaml, debe ser externa y unica para Docker.

**Resultado observado:**
El despliegue fue exitoso. Los logs del servicio mostraron "secret-mounted" verificando que el archivo existe en la ruta temporal, y las pruebas automáticas de pytest pasaron al 100%.

## Evidencias
<!-- Pegar salidas de comandos o enlaces a capturas en el PR -->
```bash
PS C:\SPEC303\DockerSwarmLab> python -m pytest -q tests/test_contracts.py --team team-03
...
4 passed in 0.06s   [100%]
```

## Limitaciones y lecciones
*   **Limitaciones:** Al ejecutarse en un entorno local de un solo nodo (donde Manager y Worker son la misma máquina), no se puede observar la distribución de secretos a través de la red usando encriptación mTLS.
*   **Lecciones (Trade-offs):** Extraer la credencial y hacerla externa mejora drásticamente la seguridad, pero sacrifica la automatización total; ahora el despliegue requiere que el secreto sea creado previamente de forma manual en la consola por un operador.