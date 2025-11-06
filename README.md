# asm_primitive_roots

Programa en ensamblador x64 que calcula exponenciación modular usando el algoritmo de exponenciación rápida.

## Requisitos

- Windows
- Microsoft Visual Studio (con las herramientas de ensamblador MASM) o Windows SDK
- `ml64.exe` (Microsoft Macro Assembler para x64)
- `link.exe` (Linker de Microsoft)

## Compilación y Ejecución

**IMPORTANTE:** Necesitas tener Visual Studio instalado con las herramientas de C++ (incluyendo MASM).

### Opción 1: Usar Developer Command Prompt (Recomendado)

1. Abre **"Developer Command Prompt for VS"** o **"x64 Native Tools Command Prompt for VS"** desde el menú de inicio de Windows
2. Navega al directorio del proyecto:
   ```bash
   cd "C:\Users\Sebastián Ceciliano\Documents\GitHub\asm_primitive_roots"
   ```
3. Ejecuta el script:
   ```bash
   build.bat
   ```

Este script automáticamente:
1. Ensambla el código fuente
2. Enlaza los objetos
3. Ejecuta el programa

### Opción 2: Usar el script que busca Visual Studio automáticamente

Ejecuta `build_with_vs.bat` desde CMD (no PowerShell):

```bash
build_with_vs.bat
```

Este script intenta encontrar Visual Studio y configurar el entorno automáticamente.

### Opción 3: Compilación manual

1. **Ensamblar el código:**
   ```bash
   ml64 /c /Fo asm_primitive_roots.obj asm_primitive_roots.asm
   ```

2. **Enlazar el objeto:**
   ```bash
   link /subsystem:console /entry:main asm_primitive_roots.obj kernel32.lib msvcrt.lib /out:asm_primitive_roots.exe
   ```

3. **Ejecutar el programa:**
   ```bash
   .\asm_primitive_roots.exe
   ```

## Configuración del entorno

Si no tienes `ml64.exe` y `link.exe` en tu PATH, necesitas abrir una "Developer Command Prompt" de Visual Studio:

1. Busca "Developer Command Prompt for VS" en el menú de inicio
2. Navega a la carpeta del proyecto
3. Ejecuta los comandos de compilación

O configura las variables de entorno manualmente para apuntar a las herramientas de Visual Studio.

## Ejemplo de salida

El programa calcula `(3 ^ 4) mod 5 = 1` y muestra:
```
Resultado: 1
```