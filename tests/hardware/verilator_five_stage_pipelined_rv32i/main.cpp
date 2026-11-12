/*

---------Vtop_fpga I/O---------

clk_from_FPGA_100MHz
rst_from_FPGA
rst_on
uart_tx_pin_for_FPGA
uart_rx_pin_from_FPGA
vga_red_for_FPGA
vga_green_for_FPGA
vga_blue_for_FPGA
vsync_for_FPGA
hsync_for_FPGA

*/

#include <SDL2/SDL.h>
#include "obj_dir/Vtop_fpga.h"

constexpr uint64_t CLK_HALF_NS = 5;

int main(int argc, const char** argv) {
    VerilatedContext* ctx = new VerilatedContext;
    ctx->commandArgs(argc, argv);
    Vtop_fpga* top = new Vtop_fpga{ctx};

    top->clk_from_FPGA_100MHz = 0;
    top->rst_from_FPGA = 1;
    ctx->timeInc(CLK_HALF_NS);
    top->eval();

    top->clk_from_FPGA_100MHz = 1;
    top->rst_from_FPGA = 0;
    ctx->timeInc(CLK_HALF_NS);
    top->eval();
    
    while(true) {
        top->clk_from_FPGA_100MHz = !top->clk_from_FPGA_100MHz;
        ctx->timeInc(CLK_HALF_NS);
        top->eval();
    }
    
    top->final();
    delete top;
    delete ctx;
    return 0;
}

// int main(int argc, char** argv) {

//     SDL_Init(SDL_INIT_VIDEO);
//     SDL_Window* window = SDL_CreateWindow("VGA Monitor Simulation", 
//                                           SDL_WINDOWPOS_CENTERED, 
//                                           SDL_WINDOWPOS_CENTERED, 
//                                           1000, 800, 0);
//     SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

//     int red = 1; 
//     int green = 0; 
//     int blue = 1;

//     while(true) {
//         SDL_Event e;
//         while (SDL_PollEvent(&e)) {
//             if (e.type == SDL_QUIT) goto cleanup;
//         }

//         uint8_t r = (red * 255);
//         uint8_t g = (green * 255);
//         uint8_t b = (blue * 255);

//         SDL_SetRenderDrawColor(renderer, r, g, b, 255);

//         for (int y = 0; y < 600; y++) {
//             for (int x = 0; x < 800; x++) {
//                 SDL_RenderDrawPoint(renderer, x, y);
//             }
//         }

//         SDL_RenderPresent(renderer);
//     }

// cleanup:
//     SDL_DestroyRenderer(renderer);
//     SDL_DestroyWindow(window);
//     SDL_Quit();
//     return 0;
// }

