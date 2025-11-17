# Security Features

## Overview

The PHP Docker images ByJG are built with security as a priority. This document explains the security features and considerations for these images.

## SBOM (Software Bill of Materials)

### What is SBOM?

A Software Bill of Materials (SBOM) is a comprehensive inventory of all software components, libraries, and dependencies included in a Docker image. It provides transparency about what's inside the container, making it easier to:

- Track software components and their versions
- Identify known vulnerabilities in dependencies
- Ensure compliance with security policies
- Respond quickly to security incidents

### How We Generate SBOM

All Docker images built from the `master` branch include SBOM metadata. This is configured in our GitHub Actions workflow (`.github/workflows/build.yml`) with:

```yaml
sbom: true
```

The SBOM is automatically generated during the image build process using Docker BuildKit's native SBOM generation capabilities. The SBOM follows the industry-standard [SPDX](https://spdx.dev/) format.

### Accessing SBOM Data

You can inspect the SBOM of any image using Docker's `sbom` command or compatible tools:

```bash
# Using docker buildx imagetools
docker buildx imagetools inspect byjg/php:8.4-base --format "{{ json .SBOM }}"

# Using docker scout (if available)
docker scout sbom byjg/php:8.4-base
```

### Why This Matters

With SBOM included in every image, you can:

1. **Vulnerability Scanning**: Automatically scan for known CVEs in image components
2. **Supply Chain Security**: Track the complete software supply chain
3. **Compliance**: Meet regulatory requirements for software transparency
4. **Incident Response**: Quickly determine if your images are affected by newly discovered vulnerabilities

## Build Provenance

### What is Build Provenance?

Build provenance is cryptographically signed metadata that documents how and where the Docker image was built. It provides verifiable proof of the image's origin and build process.

### Provenance Configuration

All images are built with maximum provenance detail:

```yaml
provenance: mode=max
```

This captures:

- **Build environment**: GitHub Actions runner details
- **Source code**: Git commit SHA, repository, and branch
- **Build steps**: Complete record of the build process
- **Materials**: All inputs used to create the image
- **Timestamp**: When the build occurred

### Verifying Provenance

You can verify the build provenance using Docker's attestation features:

```bash
# Inspect image provenance
docker buildx imagetools inspect byjg/php:8.4-base --format "{{ json .Provenance }}"
```

### SLSA Compliance

Our build process follows [SLSA](https://slsa.dev/) (Supply-chain Levels for Software Artifacts) principles:

- **Source Integrity**: All builds originate from the official GitHub repository
- **Build Integrity**: Automated builds in isolated GitHub Actions runners
- **Provenance**: Complete build attestation with `mode=max`

### Benefits of Provenance

1. **Trust**: Verify images come from the official source
2. **Auditability**: Complete audit trail of the build process
3. **Reproducibility**: Understand exactly how images were created
4. **Security**: Detect tampering or unauthorized modifications

## Alpine Version Strategy

### Current Alpine Versions

|  PHP Version  | Alpine Version | Rationale                                              |
|:-------------:|:--------------:|--------------------------------------------------------|
|      8.5      |      edge      | Required for PHP 8.5 (not yet in stable)               |
|      8.4      |      edge      | Avoid CVE-2023-27482 and other vulnerabilities in 3.22 |
|      8.3      |      edge      | Avoid CVE-2023-27482 and other vulnerabilities in 3.22 |
|      8.2      |      edge      | Avoid CVE-2023-27482 and other vulnerabilities in 3.22 |
| 8.1 and older |    Various     | Pinned to last compatible Alpine versions              |

### Why Edge for PHP 8.2, 8.3, and 8.4?

#### Alpine 3.22 Critical Vulnerabilities

Alpine 3.22 contains **critical unpatched vulnerabilities** that affect production deployments:

**CVE-2023-27482** - Supervisor Vulnerability
- Critical security issue in the supervisor package
- Remains **unfixed** in Alpine 3.22 stable branch
- No patch timeline announced by Alpine maintainers

**Additional Vulnerabilities**
- Multiple other packages in Alpine 3.22 contain known CVEs
- Security fixes are not being backported to 3.22 in a timely manner
- Alpine edge receives security updates more rapidly

#### Our Security Decision

To prioritize security, we use **Alpine edge** for actively maintained PHP versions (8.2, 8.3, 8.4):

**Advantages:**
- ✅ **Latest security patches** applied immediately
- ✅ **CVE-2023-27482** is fixed in edge
- ✅ **Other vulnerabilities** patched more quickly
- ✅ **Better security posture** overall

**Trade-offs:**
- ⚠️ Edge is a rolling release (packages update continuously)
- ⚠️ Slightly less stable than point releases
- ⚠️ May include newer package versions than expected

#### Mitigation for Edge Stability

To balance security with stability:

1. **Monthly Tagged Releases**: Images are tagged with `YYYY.MM` (e.g., `8.4-base-2025.11`)
   - Provides a stable snapshot for that month
   - Allows pinning to a specific build
   - Tested before release

2. **Testing Pipeline**: All images are built and tested in CI/CD

3. **Pin Versions in Production**: Use monthly tags instead of latest:
   ```bash
   # Instead of this (rolling):
   docker pull byjg/php:8.4-base

   # Use this (pinned):
   docker pull byjg/php:8.4-base-2025.11
   ```

### Why Edge for PHP 8.5?

PHP 8.5 is a bleeding-edge version that requires the latest packages and dependencies. Alpine Linux `edge` is:

- The **only** Alpine branch with PHP 8.5 packages
- Updated continuously with latest package versions
- Necessary for testing and development with PHP 8.5
- Marked as **8.5** in tags to clearly indicate its experimental status

**Production Use**: PHP 8.5 images are intended for:
- Development and testing environments
- Early adoption and compatibility testing
- Preview of upcoming PHP features

**Not recommended for production** until PHP 8.5 reaches stable release.

### Legacy PHP Versions (8.1 and older)

Older PHP versions use specific Alpine versions that were stable when those PHP versions were current:

- These versions no longer receive monthly builds
- Alpine versions are frozen to last known compatible version
- Use these only for legacy application support
- Recommend upgrading to PHP 8.2+ for security updates

## Security Hardening

All images implement these security practices:

### Non-Root User

Images run as the `app` user (UID 1000) instead of root:

```dockerfile
USER app
```

This limits the impact of potential security breaches.

### Minimal Attack Surface

- Only essential packages are installed
- No unnecessary tools or utilities
- Regular cleanup of build artifacts
- Alpine Linux minimal base

### No Supervisor Dependency

**Important**: These images do **not** use or install supervisor, regardless of Alpine version:

- **Base/CLI images**: No process manager needed
- **FPM images**: Single PHP-FPM process
- **FPM-Nginx images**: Multiple processes managed via shell scripts
- **FPM-Apache images**: Apache handles process management

While CVE-2023-27482 affects supervisor, our images avoid it entirely through architecture design.

### Regular Updates

Images with **Monthly Builds** tag are rebuilt every month to include:

- Latest PHP security patches
- Alpine package security updates
- Updated dependencies with fixes

## Vulnerability Scanning

### Recommended Tools

We recommend scanning images with:

1. **Docker Scout**:
   ```bash
   docker scout cves byjg/php:8.4-base
   ```

2. **Trivy**:
   ```bash
   trivy image byjg/php:8.4-base
   ```

3. **Grype**:
   ```bash
   grype byjg/php:8.4-base
   ```

All these tools can leverage the SBOM for more accurate vulnerability detection.

### Interpreting Scan Results

When scanning images built on Alpine edge:

- **"unstable" or "edge" warnings**: Expected - these are intentional for security
- **Package version "unknown"**: Alpine edge packages may not be in CVE databases yet
- **Fixed versions available**: Usually means "upgrade to next monthly build"
- **Supervisor CVEs**: Not applicable (package not installed)

### Comparing 3.22 vs Edge

If you scan both Alpine 3.22 and edge-based images, you may observe:

- **Alpine 3.22**: Shows CVE-2023-27482 and other known CVEs
- **Alpine edge**: Fewer CVEs overall, more up-to-date patches
- **Edge wins on security**: Despite "unstable" label, edge has better security posture

## Best Practices

### For Development

1. Use latest tags to get most recent packages
2. Scan images regularly for vulnerabilities
3. Review SBOM for dependency awareness
4. Pull images frequently to get security updates

### For Production

1. **Pin to specific YYYY.MM tags** for reproducibility:
   ```bash
   docker pull byjg/php:8.4-base-2025.11
   ```

2. **Test updates** before deploying new monthly releases
3. **Scan before deployment** using your preferred security tool
4. **Monitor security advisories** for PHP and Alpine
5. **Update monthly tags regularly** to get security patches
6. **Avoid PHP 8.5** (edge is acceptable for 8.2-8.4, but 8.5 itself is experimental)

### For CI/CD

1. Use SBOM for supply chain visibility
2. Verify provenance in security-critical pipelines
3. Automate vulnerability scanning
4. Pin versions in production pipelines
5. Set up automated alerts for new monthly releases

## Understanding the Security Trade-off

### The Decision: Edge vs Stable

This project prioritizes **security over stability** for modern PHP versions:

```
Alpine 3.22 (stable) ➜ Known CVEs, no patches → ❌ Rejected
Alpine edge (rolling) ➜ Latest patches, slight instability → ✅ Accepted
```

### Why This Makes Sense

1. **Known vs Unknown Risk**
   - Alpine 3.22: **Known vulnerabilities** that won't be fixed
   - Alpine edge: **Unknown minor issues** that will be fixed quickly

2. **Docker Image Context**
   - Images are immutable and versioned
   - Monthly tags provide stability checkpoints
   - Easy to rollback if edge causes issues
   - Can't rollback from a security breach

3. **Real-World Impact**
   - CVE-2023-27482 is a **critical** vulnerability
   - Edge instability is typically **minor** package updates
   - Security incidents are costlier than minor bugs

## Monitoring and Updates

We actively monitor:

- Alpine Security advisories
- PHP security announcements
- CVE databases for image components
- SBOM scanning results
- Community feedback on edge stability

Monthly image rebuilds ensure packages are updated with latest security patches available in Alpine edge.

## Reporting Security Issues

If you discover a security issue:

1. **Do not** open a public GitHub issue
2. Contact the maintainers privately via GitHub Security Advisories
3. Provide details about the vulnerability
4. Allow time for a fix before public disclosure

## Additional Resources

- [Docker SBOM Documentation](https://docs.docker.com/build/attestations/sbom/)
- [Docker Provenance Documentation](https://docs.docker.com/build/attestations/slsa-provenance/)
- [SLSA Framework](https://slsa.dev/)
- [Alpine Security](https://alpinelinux.org/security/)
- [PHP Security](https://www.php.net/security/)
- [CVE-2023-27482 Details](https://nvd.nist.gov/vuln/detail/CVE-2023-27482)

---
