# AudioEnhancer Virtual Cable

Driver de audio virtual (VAD) propio para **Audio Enhancer FxStyle**: un
"altavoz virtual" donde las aplicaciones reproducen su audio y del que la app
captura por **loopback WASAPI** (el mismo mecanismo que usa hoy con VB-Cable),
sin cambios en la app.

- **Estado**: F0 (prueba de concepto) — base: muestra **Sysvad** de Microsoft.
- **Licencia**: MIT para el código propio; las partes derivadas de Sysvad
  conservan **MS-PL** (ver `LICENSE`, `LICENSE-MS-PL` y
  `THIRD_PARTY_NOTICES.md`).
- **Requisitos de compilación** (gratis): Visual Studio 2022 (Desktop C++) +
  Windows Driver Kit (WDK) + Windows SDK.
- **Instalación de prueba**: modo *test signing* de Windows (gratis; ver
  `docs/` cuando esté disponible).

## Estructura

```
driver/   Código del driver (derivado de la muestra Sysvad, MS-PL)
tools/    Scripts de build / instalación / desinstalación (test signing)
docs/     Documentación
```

## Plan

El plan completo (validación RE, diseño, firma, fases) vive en el repositorio
de la app: `docs/PLAN-DRIVER.md`.
