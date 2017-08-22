% Práctica 2. Autómata celular
% Delavy Duque Martínez
% 21 de agosto de 2017

# Introducción

Un autómata celular es una colección de células "coloreadas" en una cuadrícula de un tamaño y figura específica, que evoluciona a lo largo del tiempo, mediante pasos, de acuerdo a reglas basadas en los estados de las células vecinas. Las reglas son aplicadas en la cuadrícula, siempre y cuando haya una viva, y pueden ser tantos pasos sean necesarios hasta que ya no quede una célula viva. [^116f864e]

#Hipótesis
Entre más probabilidad tenga de generar células vivas, las células tienen menor probabilidad de vivir.

#Simulación
En esta práctica, se simula un autómata celular. La primera parte de este experimento consiste en la simulación del juego de la vida, en el cual las reglas son simples: Para tomar en cuenta su supervivencia, se evalúa si exactamente 3 de sus 8 vecinos alrededor están vivos, si así se cumple, la célula vive.

Para realizar la primera parte, se realizó una simulación en R, en una cuadrícula con 100 celdas, o sea, de 10x10 dimensiones. El objetivo de esta simulación es determinar el número de generaciones que dura la simulación, dependiendo de la probabilidad de celdas vivas al inicio de la simulación.

Para realizar este proceso, se programó en R un ciclo que fuera recorriendo las probabilidades, desde 0.1 hasta 0.9, siendo 0.1 la menor probabilidad de que se generaran celdas vivas, y 0.9 la mayor probabilidad de generar celdas vivas, todas colocadas aleatoriamente en la cuadrícula. En el código original, estaba puesta solamente la probabilidad de 0.5, es decir, que tuviera igual probabilidad de generar celdas vivas que generar celdas muertas. Las celdas vivas están representadas por el color negro y las celdas muertas por el color blanco.

El primer reto consistía en modificar la simulación para que ahora modele algún tipo de crecimiento, en donde empiezan con celdas vivas, y cada una va creciendo, tomando a celdas vecinas, y expandirse hasta llenar la cuadrícula, con la misma tasa de crecimiento.

La simulación del reto se planteó con 8 semillas iniciales, colocadas al azar en una cuadrícula de 50x50, todas con la misma tasa de crecimiento, que en este caso fue de 1. En la programación de esta simulación, se determinó que debería haber un ciclo que recorriera la cuadrícula actual, y colocara las posiciones al azar de las semillas, que se generó con la función de _sample_ `random <- sample(1:num, semillas, replace=F)`,
luego, se guarda en la matriz actual las posiciones que salieron aleatorias del _sample_, con un ciclo _for_, también asignando color en escala de grises para cada una de las 8 semillas de la simulación.

En los ciclos siguentes, se verifica si hay lugar en blanco, para empezar a pintar la celda, verificar si hay vecinos que están en blanco para pintarlos, pero que no interfiera con los de otras celas expandidas.

#Resultados
En la primera simulación, las cuadrículas con menor probabilidad (0.1 a 0.3) de generar celdas vivas, hacían pocas generaciones. Se repitió la simulación algunas veces, y en algunos resultados no tenían generaciones, principalmente en la probabilidad de 0.1 de hacer generaciones.
Las cuadrículas con probabilidad media (0.4 a 0.6) fueron las que lograron tener más generaciones que cualquier otra probabilidad, con el mayor número de generaciones.
Por último, las cuadrículas con probabilidad alta (0.7 a 0.9) de generar celdas vivas, tenían pocas generaciones, e incluso, en algunas simulaciones, no hacían generaciones. En la siguiente figura se muestran las generaciones creadas por cada probabilidad.

![Generaciones creadas por probabilidad](p2generacionesYprobabilidad.png)

Como se puede observar, las que tienen menor probabilidad de generar celdas vivas al inicio y las que tienen mayor probabilidad de generar celdas vivas al incio, tienen muy pocas generaciones, mientras que las cuadrículas que tienen probabilidad media, tuvieron más generaciones.

En el primer reto, las semillas se acomodaban aleatoriamente, habiendo unos núcleos que se expandían más que otros. En esta simulación, al resultado final, se pintó el primer índice de la matriz de la cuadrícula, esto con motivo de que no se perdiera el color original de la simulación. En las figuras siguientes se puede apreciar cómo crecen las células puestas aleatoriamente, y en el repositorio se puede apreciar un gif de cómo van crecinedo.

![Semillas colocadas al azar, preparándose para crecer](reto1-paso0.png)

![Semillas en crecimiento a la mitad del proceso](reto1-paso11.png)

![Semillas ocupando toda la cuadrícula, en su último paso](reto1-paso22.png)

#Conclusiones
En la simulación del juego de la vida, es más probable que las celdas generen más generaciones si tienen una probabilidad media (0.4 a 0.6) de hacer celdas vivas y muertas. En el primer reto, las celdas se expandían dependiendo de la tasa de crecimiento, y lo que influenciaba en su expansión era que tan cerca se encontraba en la orilla, ya que las orillas de la cuadrícula determinan un límite, y también de si ya había otra semilla expandida cerca, ya no puede expandirse.

[^116f864e]: http://mathworld.wolfram.com/CellularAutomaton.html
