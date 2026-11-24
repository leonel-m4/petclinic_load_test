# PetClinic – Laboratorio 15: Pruebas de Rendimiento (Stress)

Proyecto basado en [jgomezz/petclinic_load_test](https://github.com/jgomezz/petclinic_load_test), preparado para pruebas de carga con JMeter.

## Estructura
| Carpeta | Contenido |
|---|---|
| `src/`, `pom.xml` | API REST Spring Boot (`/pets`, `/pets/{id}`) con perfiles Maven `local`, `dev`, `test`, `prod` |
| `data/` | `schema-mysql.sql` y `data-mysql.sql` |
| `server/` | `setup_server.sh` (MySQL + Nginx) y `nginx-default.conf` (proxy inverso 80 → 8080) |
| `jmeter/TestPlan.jmx` | Plan: Grupo de Hilos, Valores por defecto HTTP, Listar mascotas, **Buscar mascota por id**, Aserción (código 200, Substring) y listeners |
| `jmeter/run_tests.sh` | Ejecución en modo CLI para 10, 100, 1000 y 5000 hilos |
| `jmeter/result/` | Resultados (`.csv` en formato JTL), salida de `top`, gráficos y `resumen.md` |

## Pasos
```bash
# 1. Servidor (MySQL, usuario admin, esquema, Nginx)
cd server && bash setup_server.sh

# 2. Generar el jar con el perfil prod (queda en target/)
mvn clean install -DskipTests -P prod

# 3. Ejecutar la API
java -jar target/petclinic.jar --spring.profiles.active=prod
curl http://localhost/pets          # vía Nginx (puerto 80)

# 4. Pruebas de carga (modo CLI)
cd jmeter && ./run_tests.sh localhost 80
```

Parámetros del plan (se pueden sobrescribir con `-J`): `threads`, `rampup`, `loops`, `host`, `port`.

| Iteración | Hilos | Periodo de subida (s) | Bucles |
|---|---|---|---|
| 1 | 10 | 10 | 1 |
| 2 | 100 | 10 | 1 |
| 3 | 1000 | 10 | 1 |
| 4 | 5000 | 10 | 1 |
