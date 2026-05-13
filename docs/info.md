<!---

This file is used to generate your project datasheet. Please fill in the information below and delete any unused
sections.

You can also include images in this folder and reference them in the markdown. Each image must be less than
512 kb in size, and the combined size of all images must be less than 1 MB.
-->

## How it works

Este diseño genera una señal VGA estándar (640×480 a 60 Hz) para mostrar el texto "UACJ IIT" en el centro de la pantalla, sobre un fondo de color crema con un borde azul oscuro.

El corazón del sistema es el módulo hvsync_generator, que produce las señales de sincronización horizontal (hsync) y vertical (vsync), junto con las coordenadas actuales del píxel (pix_x, pix_y) y una señal display_on que indica si el píxel está dentro del área visible (no en los márgenes de blanking).

Las letras se dibujan mediante lógica combinatoria que compara la posición del píxel con rectángulos predefinidos

## How to test

Sintetizar y cargar el diseño en la FPGA/ASIC de Tiny Tapeout (mediante el flujo estándar de TT).

Conectar las salidas según la asignación de pines del chip:

uo_out[3] = VSync

uo_out[7] = HSync

uo_out[6:4] y uo_out[2:0] corresponden a los dos canales de color (R0,G0,B0 y R1,G1,B1). El diseño usa un bus de 6 bits de color (2 por canal) que se asigna a estas salidas.

Conectar el monitor VGA al chip mediante resistencias (por ejemplo, 270 Ω para cada línea de color y sincronismo) o usando un cable VGA directo si la placa ya incluye el acondicionamiento.

Alimentar la placa y aplicar una señal de reloj (normalmente 25.175 MHz para VGA 640×480@60Hz). El diseño asume que clk ya tiene esa frecuencia.

El monitor debe mostrar el texto "UACJ IIT" centrado sobre fondo crema con borde azul. Si no se ve, compruebe:

La frecuencia de reloj.

Las conexiones de VSync y HSync.

Los niveles de voltaje de las señales de color (deben ser 0 V o ~0.7 V).

## External hardware

Una placa Tiny Tapeout (demo o ASIC) con salida VGA.

Un monitor VGA o un conversor HDMI-VGA.

Alimentación y reloj externo (normalmente proporcionados por la placa).
