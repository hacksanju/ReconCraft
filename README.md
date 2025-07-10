# 🔍 ReconCraft – Automated Subdomain & Vulnerability Recon Tool

ReconCraft is a powerful bash script that automates the reconnaissance process for any target domain. It performs comprehensive subdomain enumeration, DNS resolution, URL harvesting, vulnerability pattern detection, and scanning using well-known community tools like `subfinder`, `gau`, `gf`, `nuclei`, and more.

---

## 🚀 Features

- Subdomain enumeration using:
  - `subfinder`, `assetfinder`, and `amass`
- Live subdomain verification with `dnsx`
- URL harvesting from:
  - `gau` and `waybackurls`
- JavaScript file link extraction
- GF pattern matching for vulnerabilities:
  - XSS, LFI, SSRF, SQLi, IDOR
- Vulnerability scanning with `nuclei` (critical, high, medium severity)

---

## 🛠 Requirements

Before running ReconCraft, ensure the following tools are installed and available in your system’s `$PATH`:

| Tool         | Purpose                                      | Install Command (Go-based)                                  |
|--------------|----------------------------------------------|-------------------------------------------------------------|
| `subfinder`  | Passive subdomain enumeration                | `go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest` |
| `assetfinder`| Subdomain discovery                          | `go install github.com/tomnomnom/assetfinder@latest`        |
| `amass`      | Passive subdomain enumeration                | `go install github.com/owasp-amass/amass/v4/...@latest`     |
| `dnsx`       | DNS resolution of subdomains                 | `go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest` |
| `gau`        | Grab archived URLs                           | `go install github.com/lc/gau/v2/cmd/gau@latest`            |
| `waybackurls`| Collect URLs from Wayback Machine            | `go install github.com/tomnomnom/waybackurls@latest`        |
| `gf`         | Pattern matching for vulnerability detection| `go install github.com/tomnomnom/gf@latest`                 |
| `nuclei`     | Vulnerability scanning using templates       | `go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest` |

> ✅ After installing `gf`, clone the patterns:
> ```bash
> mkdir -p ~/.gf && git clone https://github.com/1ndianl33t/Gf-Patterns ~/.gf
> ```

---

## 🚀 Usage

Make the script executable and run it against your target domain:

```bash
chmod +x Reconcraft.sh
./Reconcraft.sh example.com

##Help and version info:

 
./Reconcraft.sh -h       # Show help message
./Reconcraft.sh --help   # Show help message
./Reconcraft.sh -v       # Show version
