# Projet CI/CD Terraform Scalingo

Ce projet permet de déployer une application multi-processus (React frontend, Node.js backend, Python API) sur Scalingo à l'aide de Terraform.

## Structure du projet

- `Scalingo/` : Contient le fichier `main.tf` à utiliser pour le déploiement sur Scalingo.
- `server/`, `Docker/`, etc. : Autres dossiers liés au projet.

## Déploiement sur Scalingo

1. **Aller dans le dossier Scalingo**
   ```sh
   cd Scalingo
   ```
2. **Initialiser Terraform**
   ```sh
   terraform init
   ```
3. **Configurer votre token Scalingo**
   - Ajoutez votre token dans un fichier `terraform.tfvars` :
     ```
     scalingo_token = "VOTRE_TOKEN_ICI"
     ```
4. **Appliquer la configuration**
   ```sh
   terraform apply
   ```
5. **Pousser votre code sur Scalingo**
   - Initialisez un dépôt git dans votre monorepo si ce n'est pas déjà fait.
   - Ajoutez Scalingo comme remote :
     ```sh
     scalingo --app monorepo-terraform git-setup
     ```
   - Poussez votre code :
     ```sh
     git push scalingo main
     ```

## Remarques

- Le fichier `main.tf` à utiliser pour le déploiement Scalingo se trouve dans le dossier `Scalingo`.
