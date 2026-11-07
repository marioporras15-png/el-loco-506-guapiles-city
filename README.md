# EL LOCO 506: GUÁPILES CITY

Prototipo inicial 3D para Android, hecho con Godot 4 (renderer GL Compatibility).

## Qué incluye
- Personaje 3D provisional inspirado en El Loco (camiseta azul y pantaloneta gris).
- Cámara en tercera persona.
- Bloqueo urbano jugable inspirado en el centro de Guápiles y su Parque Central.
- Cuatro marcadores de misión y recompensas.
- HUD y controles básicos en pantalla; teclado WASD + espacio para probar en PC.

## Importante sobre el mapa
Esta primera versión es un **blockout aproximado**, basado en las capturas compartidas: todavía no es una reproducción georreferenciada ni a escala de Guápiles. Para hacerla fiel hacen falta puntos/recorridos confirmados, medidas o datos cartográficos utilizables y revisión de calles, edificios y accesos.

## Abrir y probar
1. Instalar Godot 4.3 o posterior.
2. Importar `project.godot`.
3. Ejecutar `scenes/main.tscn`.

## Exportar APK
1. En Godot, instalar las plantillas de exportación desde Editor > Manage Export Templates.
2. Configurar Android SDK/JDK según la documentación de Godot.
3. Project > Export > Add Android.
4. Configurar paquete, por ejemplo `com.el loco506.guapilescity` (sin espacios: `com.elloco506.guapilescity`).
5. Exportar APK de debug para pruebas; para distribución crear y proteger un keystore de release.

## Próximas etapas
- Reemplazar el blockout por mapa más preciso del centro de Guápiles.
- Modelo 3D del personaje basado fielmente en la foto de referencia.
- Movimiento continuo con joystick táctil, cámara táctil y colisiones refinadas.
- Misiones completas: boulevard (4 km), parkour del parque, tope Toro Amarillo–Polideportivo y trivia de colegios.
- Optimización, pruebas en dispositivo Android y APK firmado.

Este paquete contiene el proyecto fuente. No incluye un APK compilado.
