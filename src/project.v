/*
 * Copyright (c) 2024 Tiny Tapeout LTD
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none
`define VGA_REGISTERED_OUTPUTS

module tt_um_rejunity_vga_logo (
  input  wire [7:0] ui_in,
  output wire [7:0] uo_out,
  input  wire [7:0] uio_in,
  output wire [7:0] uio_out,
  output wire [7:0] uio_oe,
  input  wire       ena,
  input  wire       clk,
  input  wire       rst_n
);

  // Declaración de señales VGA
  wire [1:0] R, G, B;
  wire [9:0] pix_x, pix_y;
  wire hsync, vsync, video_active;
  
  // Generador VGA
  hvsync_generator hvsync_gen(
    .clk(clk),
    .reset(~rst_n),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(video_active),
    .hpos(pix_x),
    .vpos(pix_y)
  );


  // PARÁMETROS DE TEXTO - Todo constante

  localparam CHAR_WIDTH = 50;
  localparam CHAR_HEIGHT = 50;
  localparam CHAR_SPACING = 55;
  localparam STROKE = 6;
  
  // Posiciones constantes (pre-calculadas)
  localparam TOTAL_WIDTH = 8 * CHAR_SPACING;
  localparam START_X = (640 - TOTAL_WIDTH) / 2;  // 100
  localparam START_Y = (480 - CHAR_HEIGHT) / 2;  // 215
  
  // Posiciones de cada letra
  localparam U_X = START_X;
  localparam A_X = START_X + CHAR_SPACING;
  localparam C_X = START_X + 2 * CHAR_SPACING;
  localparam J_X = START_X + 3 * CHAR_SPACING;
  localparam SPACE_X = START_X + 4 * CHAR_SPACING;
  localparam I1_X = START_X + 5 * CHAR_SPACING;
  localparam I2_X = START_X + 6 * CHAR_SPACING;
  localparam T_X = START_X + 7 * CHAR_SPACING;
  
  // Y constante para todas las letras
  localparam CHAR_Y = START_Y;
  
  
  // LETRA U - Patrón simplificado
  
  wire is_U;
  assign is_U = (pix_x >= U_X && pix_x < U_X + CHAR_WIDTH && pix_y >= CHAR_Y && pix_y < CHAR_Y + CHAR_HEIGHT) &&
                ((pix_x - U_X) < STROKE ||                                    // borde izquierdo
                 (pix_x - U_X) >= CHAR_WIDTH - STROKE ||                      // borde derecho
                 ((pix_y - CHAR_Y) >= CHAR_HEIGHT - STROKE &&                 // borde inferior
                  (pix_x - U_X) >= STROKE && (pix_x - U_X) < CHAR_WIDTH - STROKE));
  
 
  // LETRA A

  wire is_A;
  assign is_A = (pix_x >= A_X && pix_x < A_X + CHAR_WIDTH && pix_y >= CHAR_Y && pix_y < CHAR_Y + CHAR_HEIGHT) &&
                (((pix_y - CHAR_Y) < STROKE) ||                                // borde superior
                 ((pix_x - A_X) < STROKE) ||                                   // borde izquierdo
                 ((pix_x - A_X) >= CHAR_WIDTH - STROKE) ||                     // borde derecho
                 ((pix_y - CHAR_Y) >= CHAR_HEIGHT/2 - STROKE/2 && 
                  (pix_y - CHAR_Y) <= CHAR_HEIGHT/2 + STROKE/2));              // barra media
  

  // LETRA C

  wire is_C;
  assign is_C = (pix_x >= C_X && pix_x < C_X + CHAR_WIDTH && pix_y >= CHAR_Y && pix_y < CHAR_Y + CHAR_HEIGHT) &&
                (((pix_y - CHAR_Y) < STROKE) ||                                // borde superior
                 ((pix_y - CHAR_Y) >= CHAR_HEIGHT - STROKE) ||                 // borde inferior
                 ((pix_x - C_X) < STROKE));                                    // borde izquierdo
  

  // LETRA J

  wire is_J;
  assign is_J = (pix_x >= J_X && pix_x < J_X + CHAR_WIDTH && pix_y >= CHAR_Y && pix_y < CHAR_Y + CHAR_HEIGHT) &&
                (((pix_y - CHAR_Y) < STROKE) ||                                // borde superior
                 ((pix_x - J_X) >= CHAR_WIDTH/2 - STROKE/2 && 
                  (pix_x - J_X) <= CHAR_WIDTH/2 + STROKE/2) ||                 // vertical central
                 ((pix_y - CHAR_Y) >= CHAR_HEIGHT - STROKE &&                  // parte inferior
                  (pix_x - J_X) < CHAR_WIDTH - 15));
  
 
  // LETRA I

  wire is_I;
  assign is_I = (pix_x >= I1_X && pix_x < I1_X + CHAR_WIDTH && pix_y >= CHAR_Y && pix_y < CHAR_Y + CHAR_HEIGHT) &&
                (((pix_y - CHAR_Y) < STROKE) ||                                // borde superior
                 ((pix_y - CHAR_Y) >= CHAR_HEIGHT - STROKE) ||                 // borde inferior
                 ((pix_x - I1_X) >= CHAR_WIDTH/2 - STROKE/2 && 
                  (pix_x - I1_X) <= CHAR_WIDTH/2 + STROKE/2));                 // vertical central
  
  // Segunda I (misma lógica)
  wire is_I2;
  assign is_I2 = (pix_x >= I2_X && pix_x < I2_X + CHAR_WIDTH && pix_y >= CHAR_Y && pix_y < CHAR_Y + CHAR_HEIGHT) &&
                 (((pix_y - CHAR_Y) < STROKE) ||
                  ((pix_y - CHAR_Y) >= CHAR_HEIGHT - STROKE) ||
                  ((pix_x - I2_X) >= CHAR_WIDTH/2 - STROKE/2 && 
                   (pix_x - I2_X) <= CHAR_WIDTH/2 + STROKE/2));
  

  // LETRA T

  wire is_T;
  assign is_T = (pix_x >= T_X && pix_x < T_X + CHAR_WIDTH && pix_y >= CHAR_Y && pix_y < CHAR_Y + CHAR_HEIGHT) &&
                (((pix_y - CHAR_Y) < STROKE) ||                                // borde superior
                 ((pix_x - T_X) >= CHAR_WIDTH/2 - STROKE/2 && 
                  (pix_x - T_X) <= CHAR_WIDTH/2 + STROKE/2));                  // vertical central
  
  // Texto completo
  wire is_text;
  assign is_text = is_U || is_A || is_C || is_J || is_I || is_I2 || is_T;
  
 
  // COLORES - Fondo claro

  localparam COLOR_BACKGROUND = 6'b11_10_01;  // Amarillo claro / crema
  localparam COLOR_TEXT = 6'b00_00_00;        // Negro
  localparam COLOR_BORDER = 6'b00_00_11;      // Azul oscuro
  
  // Marco decorativo
  wire border = (pix_x >= 10 && pix_x < 630 && pix_y >= 10 && pix_y < 470) &&
                (pix_x < 15 || pix_x >= 625 || pix_y < 15 || pix_y >= 465);
  
  // Selección de color
  wire [5:0] color;
  assign color = border ? COLOR_BORDER : 
                 is_text ? COLOR_TEXT : 
                 COLOR_BACKGROUND;
  
  // Salida VGA (2 bits por color)
  assign {R, G, B} = ~video_active ? 0 : 
                     {color[5:4], color[3:2], color[1:0]};

  // Salidas
`ifdef VGA_REGISTERED_OUTPUTS
  reg [7:0] UO_OUT;
  always @(posedge clk)
    UO_OUT <= {hsync, B[0], G[0], R[0], vsync, B[1], G[1], R[1]};
  assign uo_out = UO_OUT;
`else
  assign uo_out = {hsync, B[0], G[0], R[0], vsync, B[1], G[1], R[1]};
`endif

  assign uio_out = 0;
  assign uio_oe  = 0;
  wire _unused_ok = &{ena, ui_in, uio_in};

endmodule
