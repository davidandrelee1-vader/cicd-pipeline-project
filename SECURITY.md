# Security Policy

## Vulnerability Management

Container images in this project are scanned with Trivy during the
Jenkins CI/CD pipeline.

The pipeline checks for HIGH and CRITICAL vulnerabilities before an
image is approved for deployment.

## Current Security Findings

### Finding 1 — msgpack

- Severity: HIGH
- Detected Version: 1.1.2
- Fixed Version: 1.2.1
- Image: cicd-pipeline-app:1.4
- Scanner: Trivy
- Status: Under Investigation

Investigation:
Trivy detected msgpack through SBOM metadata. However, running
`pip show msgpack` inside the final application container did not
identify msgpack as an installed Python package.

Remediation Plan:
Determine the source of the SBOM finding and whether the vulnerable
package is present in a runtime-accessible image layer. If confirmed,
upgrade or remove the affected package and rebuild the image.

---

### Finding 2 — setuptools

- Severity: HIGH
- Detected Version: 70.3.0
- Fixed Version: 78.1.1
- Image: cicd-pipeline-app:1.4
- Scanner: Trivy
- Status: Under Investigation

Investigation:
Trivy detected setuptools through SBOM metadata. However, running
`pip show setuptools` inside the final application container did not
identify setuptools as an installed Python package.

Remediation Plan:
Determine the source of the SBOM finding and whether the vulnerable
package is present in a runtime-accessible image layer. If confirmed,
upgrade or remove the affected package and rebuild the image.

## Temporary Risk Exception

These findings are documented for investigation while development
of the CI/CD lab continues.

This exception does not classify the vulnerabilities as resolved.

Before a production deployment, the findings should be:

1. Remediated and verified by a new security scan, or
2. Reviewed and formally accepted through the organization's
   vulnerability/risk exception process.

## Security Controls

Current CI pipeline controls include:

- Black formatting checks
- pytest automated testing
- Docker image builds
- Trivy vulnerability scanning
- HIGH/CRITICAL vulnerability security gate

## Future Security Improvements

Planned improvements include:

- Amazon ECR image storage
- ECR image scanning
- IAM least-privilege access
- Secrets Manager / Parameter Store
- Runtime monitoring and logging
- Automated deployment controls