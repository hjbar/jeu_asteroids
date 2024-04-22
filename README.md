<h1> Jeu Asteroids </h1>

<h2> Année : L3 </h2>
<h2> Langage : OCaml </h2>

<h3> Comment compiler le projet </h3>

<p>
La liste des dépendances du projet.

Dépendances :
  - ocaml
  - js_of_ocaml
  - js_of_ocaml-ppx
  - pps
  - dune
  - tsdl
  - tsdl*-image
  - tsdl-mixer
  - tsdl-ttf
  - ocamlformat
</p>

<p>
Construire le projet : make
<br>
<br>  
Lancer le jeu avec Javascript (conseillé) :
<br>
Ouvrir un terminal à la racine du projet, puis lancer la commande : python3 -m http.server
<br>
Ouvrir un navigateur et aller à l'adresse : http://localhost:8000
<br>
<br>
Lancer le jeu version SDL : make exec
</p>

<h3> Description et objectifs </h3>

<p> 
Le but du projet est la conception d'un jeu en OCaml en utilisant le modèle ECS (entity-component-system).

Il permet entre autre de se familiariser avec :
  - Le modèle ECS
  - La conception de jeu AABB (Axis Aligned Bounding Box)
  - Les moteurs physiques
  - La compilation de langages de haut niveau vers Javascript
  - L'utilisation de git
</p>
