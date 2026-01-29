# Gitea - Serveur Git Léger

## 📋 Informations Étudiant

| Champ | Valeur |
|-------|--------|
| **Nom** | MNAGUI MPANGOL FELICITE MELISSA |
| **Matricule** | 22U2028 |
| **Application** | Gitea |
| **URL** | https://22u2028.systeme-res30.app |
| **Cours** | INF3611 - Administration Systèmes |
| **Université** | Université de Yaoundé I |

---

## 📖 Description de l'Application

**Gitea** est une solution légère et auto-hébergée de forge Git. C'est une alternative open-source à GitHub, GitLab et Bitbucket, écrite en Go.

### Cas d'usage en entreprise

1. **Hébergement de code privé** : Les entreprises peuvent héberger leurs dépôts de code source en interne, garantissant la confidentialité et le contrôle total sur leur propriété intellectuelle.

2. **Gestion de projets** : Gitea offre des fonctionnalités de gestion de projets comme les issues, les pull requests, les wikis et les tableaux Kanban.

3. **CI/CD intégré** : Avec Gitea Actions (similaire à GitHub Actions), les équipes peuvent automatiser leurs pipelines de build, test et déploiement.

4. **Conformité et audit** : Pour les entreprises soumises à des réglementations strictes (finance, santé), héberger son propre serveur Git permet de respecter les exigences de conformité.

---

## 🚀 Instructions de Démarrage

### Prérequis
- Docker et Docker Compose installés
- Accès SSH au VPS
- Ports 5080 et 5090 disponibles

### Étapes de déploiement

```bash
# 1. Cloner ou copier le projet sur le VPS
scp -r 22U2028/ user@vps:/chemin/

# 2. Se connecter au VPS
ssh user@vps

# 3. Aller dans le dossier du projet
cd /chemin/22U2028

# 4. Créer les dossiers pour les bind volumes
mkdir -p gitea_app/data gitea_app/config gitea_app/postgres

# 5. Démarrer les conteneurs
docker-compose up -d

# 6. Vérifier que tout fonctionne
docker-compose ps
docker logs gitea_22U2028

# 7. Copier la configuration Nginx
sudo cp nginx-22u2028.conf /etc/nginx/sites-available/22u2028.conf
sudo ln -sf /etc/nginx/sites-available/22u2028.conf /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
```

### Accès à l'application
- **URL** : https://22u2028.system-reso3.cm
- **SSH Git** : ssh://git@22u2028.systeme-res30.app:2222

---

## 🔧 Explication des Services

### Service `gitea`
Le service principal qui héberge le serveur Gitea. Il :
- Expose le port 3000 (HTTP) mappé sur 5080
- Expose le port 22 (SSH) mappé sur 5090
- Utilise PostgreSQL comme base de données
- Stocke les données dans des bind volumes

### Service `db` (PostgreSQL)
Base de données relationnelle qui stocke :
- Les utilisateurs et leurs informations
- Les métadonnées des dépôts
- Les issues, pull requests, wikis
- Les configurations

---

## 🔐 Variables d'Environnement

| Variable | Description |
|----------|-------------|
| `GITEA_DOMAIN` | Domaine principal de Gitea |
| `GITEA_ROOT_URL` | URL complète avec https |
| `POSTGRES_DB` | Nom de la base de données |
| `POSTGRES_USER` | Utilisateur PostgreSQL |
| `POSTGRES_PASSWORD` | Mot de passe PostgreSQL (⚠️ secret) |
| `GITEA_HTTP_PORT` | Port HTTP externe (5080) |
| `GITEA_SSH_PORT` | Port SSH externe (5090) |
| `SMTP_HOST` | Serveur SMTP pour les emails |
| `SMTP_PORT` | Port SMTP (587 pour TLS) |
| `SMTP_USER` | Utilisateur SMTP |
| `SMTP_PASSWORD` | Mot de passe SMTP (⚠️ secret) |
| `TZ` | Fuseau horaire (Africa/Douala) |

---

## 🔒 Génération du Certificat TLS

Le certificat SSL est un certificat wildcard pour le domaine principal. Commande utilisée :

```bash
# Génération du certificat wildcard avec Certbot
sudo certbot certonly \
  --manual \
  --preferred-challenges=dns \
  -d "*.systeme-res30.app" \
  -d "systeme-res30.app" \
  --email admin@systeme-res30.app \
  --agree-tos
```

Ou si un certificat spécifique est nécessaire :

```bash
sudo certbot --nginx -d 22u2028.systeme-res30.app
```

---

## 💾 Persistance des Données

Les données sont persistées via des **bind volumes** :

| Chemin Conteneur | Chemin Hôte | Description |
|------------------|-------------|-------------|
| `/data` | `./gitea_app/data` | Données Gitea (repos, LFS, avatars) |
| `/data/gitea/conf` | `./gitea_app/config` | Configuration Gitea |
| `/var/lib/postgresql/data` | `./gitea_app/postgres` | Base de données PostgreSQL |

### Avantages des bind volumes :
1. **Sauvegarde facile** : Les données sont accessibles directement sur le système hôte
2. **Portabilité** : Facile à migrer vers un autre serveur
3. **Inspection** : Possibilité d'examiner les fichiers sans accéder au conteneur
4. **Récupération** : En cas de crash du conteneur, les données restent intactes

---

## 💰 Monétisation de l'Application

### Modèles de revenus possibles avec Gitea :

1. **Service d'hébergement Git managé (SaaS)**
   - Offrir un service Git hébergé pour les PME
   - Tarification par utilisateur ou par dépôt
   - Exemple : 5$/utilisateur/mois

2. **Support et maintenance**
   - Contrats de support pour les entreprises
   - Installation et configuration personnalisée
   - Formation des équipes

3. **Intégration CI/CD**
   - Offrir des runners de build hébergés
   - Facturer les minutes de build
   - Intégration avec des services cloud

4. **Fonctionnalités premium**
   - Audit avancé et conformité
   - Intégration LDAP/SSO
   - Sauvegarde automatique

5. **Consulting DevOps**
   - Migration depuis GitHub/GitLab
   - Mise en place de workflows Git
   - Automatisation des déploiements

### Estimation de revenus :
- **10 clients PME** à 50$/mois = **500$/mois**
- **Support annuel** = **2000-5000$/an** par client
- **Consulting** = **50-100$/heure**

---

## 📝 Notes Supplémentaires

### Première connexion
Lors de la première visite, créez un compte administrateur. Le premier utilisateur enregistré devient automatiquement administrateur.

### Commandes utiles

```bash
# Voir les logs en temps réel
docker logs -f gitea_22U2028

# Accéder au shell du conteneur
docker exec -it gitea_22U2028 bash

# Redémarrer les services
docker-compose restart

# Arrêter les services
docker-compose down

# Mettre à jour Gitea
docker-compose pull
docker-compose up -d
```

---

**Date de création** : 26 janvier 2026  
**Deadline** : 27 janvier 2026, 08h00
