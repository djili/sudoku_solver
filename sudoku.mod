# Matrice : représente les valeurs de départ qui sont fixées
param Matrice{1..9, 1..9}, integer, >= 0, <= 9, default 0;

# sortie.txt : nom du fichier de sortie
param sortie, symbolic := "sortie.txt";

# i représente l'indice de la ligne courante
# j représente l'indice de la colonne courante
# k représente l'indice du carré courante (3x3)
# x[i,j,k] = 1 : la case [i,j] est affecté à la valeur k
var x{i in 1..9, j in 1..9, k in 1..9}, binary;


# la liste des contraintes
subject to
#On attribue les valeurs fixée à la variable x, qu'on affecte à 1 si la valeur est fixée 0 sinon
constr1{i in 1..9, j in 1..9, k in 1..9: Matrice[i,j] != 0}:
     x[i,j,k] = (if Matrice[i,j] = k then 1 else 0);

#chaque cellule doit avoir exactement une valeur
constr2{i in 1..9, j in 1..9}: sum{k in 1..9} x[i,j,k] = 1;

#les cellules de la même ligne doivent se voir attribuer des valeurs distincts
constr3{i in 1..9, k in 1..9}: sum{j in 1..9} x[i,j,k] = 1;

#les cellules de la même colonne doivent se voir attribuer des valeurs distincts
constr4{j in 1..9, k in 1..9}: sum{i in 1..9} x[i,j,k] = 1;

#les cellules de la même région (carré) doivent se voir attribuer des valeurs distincts
constr5{I in 1..9 by 3, J in 1..9 by 3, k in 1..9}:
     sum{i in I..I+2, j in J..J+2} x[i,j,k] = 1;

solve;
printf("") > sortie;
for {i in 1..9}
{      
  for {j in 1..9}
  {  
    for {0..0: i * j = 1} printf("[") >> sortie;
    
    printf "[%d,%d,%d]", i, j, sum{k in 1..9} x[i,j,k] * k >> sortie;

    for {0..0: i * j != 81} printf(",") >> sortie;

    for {0..0: i * j = 81} printf("]\n") >> sortie;
  }
}
