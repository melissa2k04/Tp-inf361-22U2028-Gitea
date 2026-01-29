#!/bin/bash
# ============================================================
# Script de déploiement Gitea
# Étudiante: MNAGUI MPANGOL FELICITE MELISSA
# Matricule: 22U2028
# ============================================================

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}================================================${NC}"
echo -e "${CYAN}  DÉPLOIEMENT GITEA - 22U2028${NC}"
echo -e "${CYAN}================================================${NC}"
echo ""

# Vérifier Docker
echo -e "${YELLOW}[1/5] Vérification de Docker...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}✗ Docker n'est pas installé${NC}"
    exit 1
fi
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}✗ Docker Compose n'est pas installé${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker est installé${NC}"

# Créer les dossiers
echo -e "${YELLOW}[2/5] Création des dossiers de données...${NC}"
mkdir -p gitea_app/data
mkdir -p gitea_app/postgres

# Permissions pour Gitea (UID 1000 par défaut)
chown -R 1000:1000 gitea_app/data 2>/dev/null || sudo chown -R 1000:1000 gitea_app/data
chmod -R 755 gitea_app
echo -e "${GREEN}✓ Dossiers créés avec les bonnes permissions${NC}"

# Arrêter les anciens conteneurs si existants
echo -e "${YELLOW}[3/5] Nettoyage des anciens conteneurs...${NC}"
docker-compose down 2>/dev/null || true
echo -e "${GREEN}✓ Nettoyage terminé${NC}"

# Démarrer les conteneurs
echo -e "${YELLOW}[4/5] Démarrage des conteneurs...${NC}"
docker-compose up -d
echo -e "${GREEN}✓ Conteneurs démarrés${NC}"

# Attendre que Gitea soit prêt
echo -e "${YELLOW}[5/5] Attente du démarrage de Gitea (60s)...${NC}"
sleep 10
for i in {1..12}; do
    if curl -s http://localhost:5080 > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Gitea est prêt !${NC}"
        break
    fi
    echo "   Attente... ($((i*5))s)"
    sleep 5
done

# Afficher le statut
echo ""
echo -e "${CYAN}================================================${NC}"
echo -e "${GREEN}  DÉPLOIEMENT TERMINÉ !${NC}"
echo -e "${CYAN}================================================${NC}"
echo ""
docker-compose ps
echo ""
echo -e "${GREEN}Gitea est accessible sur:${NC}"
echo "  - Local: http://localhost:5080"
echo "  - HTTPS: https://22u2028.systeme-res30.app"
echo "  - SSH Git: ssh://git@22u2028.systeme-res30.app:2222"
echo ""
echo -e "${YELLOW}N'oubliez pas de configurer Nginx !${NC}"
echo "  sudo cp nginx-22u2028.conf /etc/nginx/sites-available/"
echo "  sudo ln -sf /etc/nginx/sites-available/nginx-22u2028.conf /etc/nginx/sites-enabled/"
echo "  sudo nginx -t && sudo systemctl reload nginx"
echo ""
