#!/bin/bash 
# ReconCraft v 1.0
# Powered by Hacksanju
# visit https://github.com/hacksanju  

# === Colors ===
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
RESET="\e[0m" 

# === Print tool info on script start ===
echo -e "\n\e[1;32m=============================================================="
echo -e " Tool Name     : ReconCraft"
echo -e " Version       : 1.0"
echo -e " Author        : Sanjay Ghodake"
echo -e " GitHub        : https://github.com/hacksanju"
echo -e " License       : MIT"
echo -e " Created Date  : July 2025"
echo -e " Last Updated  : July 10, 2025"
echo -e " Description   : Automated reconnaissance toolkit for recon tasks"
echo -e "==============================================================\e[0m\n"

# === Check domain input ===
if [ -z "$1" ]; then
    echo -e "${RED}Usage: $0 <domain>${RESET}"
    exit 1
fi 

domain=$1
timestamp=$(date +"%Y%m%d-%H%M")
output_dir="${domain}_recon_${timestamp}"
mkdir -p "$output_dir/gf"
cd "$output_dir" || exit

echo -e "${GREEN}[+] Starting recon for $domain...${RESET}"

# === Tool check ===
tools=(subfinder assetfinder amass gau waybackurls gf nuclei dnsx)
for tool in "${tools[@]}"; do
    if ! command -v "$tool" &>/dev/null; then
        echo -e "${RED}[-] $tool is not installed. Please install it.${RESET}"
        exit 1
    fi
done

# === Subdomain Enumeration ===
echo -e "${YELLOW}[+] Enumerating subdomains...${RESET}"
subfinder -d "$domain" -silent >> subs.txt
assetfinder --subs-only "$domain" >> subs.txt
amass enum -passive -d "$domain" >> subs.txt
sort -u subs.txt -o subs.txt

# === DNS Resolution ===
echo -e "${YELLOW}[+] Validating live subdomains with DNSX...${RESET}"
dnsx -l subs.txt -silent -o resolved.txt

# === URL Collection ===
echo -e "${YELLOW}[+] Collecting URLs from gau and waybackurls...${RESET}"
gau "$domain" >> urls.txt
cat subs.txt | waybackurls >> urls.txt
sort -u urls.txt -o urls.txt

# === JavaScript File Extraction ===
echo -e "${YELLOW}[+] Extracting JavaScript file links...${RESET}"
cat urls.txt | grep '\.js' | sort -u > jsfiles.txt

# === GF Pattern Matching ===
echo -e "${YELLOW}[+] Searching for potential vulnerabilities with gf...${RESET}"
cat urls.txt | gf xss > gf/xss.txt
cat urls.txt | gf lfi > gf/lfi.txt
cat urls.txt | gf ssrf > gf/ssrf.txt
cat urls.txt | gf sqli > gf/sqli.txt
cat urls.txt | gf idor > gf/idor.txt

# === Nuclei Scanning ===
echo -e "${YELLOW}[+] Scanning with nuclei (critical/high/medium)...${RESET}"
nuclei -l resolved.txt -severity critical,high,medium -o nuclei.txt

# === Summary ===
echo -e "${GREEN}\n[+] Recon Complete! Results saved in $output_dir${RESET}"
echo -e "${GREEN}[+] Summary:${RESET}"
echo "[*] Subdomains found: $(wc -l < subs.txt)"
echo "[*] Resolved domains: $(wc -l < resolved.txt)"
echo "[*] URLs collected: $(wc -l < urls.txt)"
echo "[*] JavaScript files: $(wc -l < jsfiles.txt)"
echo "[*] Nuclei findings: $(wc -l < nuclei.txt)"
