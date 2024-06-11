#include <stdio.h>

int main() {
    int maximo = 32;
    int vetor[maximo+1];
    int finalizado=0;
    int i, j, contador;

    for(i=1; i<=maximo; i++){
        vetor[i] = i;
    }

    i = 1;
    while(finalizado==0){
        i++;
        contador = 1;
        if(vetor[i] == i) {
            for(j=i; j<=maximo; j+= i) {
                contador++;
                vetor[j+i] = 0;
                if(maximo <= j+i){
                    if(contador <= i) {
                        finalizado = 1;
                    }
                }
                printf("vetor[%d]: %d\n", j, vetor[j]);
            }
            printf("\n");
        }
    }

    printf("\nVETOR FINAL:\n");

    for(i=1; i<=maximo; i++){
        printf("vetor[%d]: %d\n", i, vetor[i]);
    }

    return 0;
}