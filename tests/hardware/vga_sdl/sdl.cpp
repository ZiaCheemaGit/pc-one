#include <SDL2/SDL.h>
#include <iostream>

int main(int argc, char** argv) {

    SDL_Init(SDL_INIT_VIDEO);
    SDL_Window* window = SDL_CreateWindow("VGA Monitor Simulation", 
                                          SDL_WINDOWPOS_CENTERED, 
                                          SDL_WINDOWPOS_CENTERED, 
                                          1000, 800, 0);
    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

    int red = 1; 
    int green = 0; 
    int blue = 1;

    while(true) {
        SDL_Event e;
        while (SDL_PollEvent(&e)) {
            if (e.type == SDL_QUIT) goto cleanup;
        }

        uint8_t r = (red * 255);
        uint8_t g = (green * 255);
        uint8_t b = (blue * 255);

        SDL_SetRenderDrawColor(renderer, r, g, b, 255);

        for (int y = 0; y < 600; y++) {
            for (int x = 0; x < 800; x++) {
                SDL_RenderDrawPoint(renderer, x, y);
            }
        }

        SDL_RenderPresent(renderer);
    }

cleanup:
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}
