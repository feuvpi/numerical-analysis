# Deployment Guide for Numerus

## Pre-Deployment Checklist

### 1. Update Version Numbers
   - Update version in `numerical-analysis-lib.cabal` to 0.0.9
   - Ensure CHANGELOG.md is updated with latest version and date
   - Check all version references in documentation

### 2. Documentation Review
```bash
# Generate and review documentation locally
cabal haddock --enable-documentation
```
   - Ensure all modules have proper Haddock documentation
   - Review README.md for accuracy
   - Check all examples are up to date

### 3. Test Suite
```bash
# Run full test suite
cabal test
```
   - Verify all tests pass
   - Check test coverage
   - Add missing test cases if needed

## GitHub Setup

### 1. Initialize Repository
```bash
git init
git add .
git commit -m "Initial release v0.0.9"
```

### 2. Create GitHub Repository
   - Go to github.com and create new repository
   - Add remote and push:
```bash
git remote add origin <your-github-repo-url>
git push -u origin main
```

### 3. Setup CI/CD
   - Add `.github/workflows/haskell.yml` for GitHub Actions
   - Configure build and test automation
   - Setup documentation generation

## Hackage Deployment

### 1. Create Hackage Account
   - Visit: [https://hackage.haskell.org](https://hackage.haskell.org)
   - Register new account
   - Get account verified

### 2. Prepare Package
```bash
# Create source distribution
cabal sdist

# Build documentation
cabal haddock --enable-documentation --haddock-for-hackage

# Create documentation tarball
cabal sdist --doc
```

### 3. Upload to Hackage
```bash
# Upload package
cabal upload dist-newstyle/sdist/numerical-analysis-lib-0.0.9.tar.gz

# Upload documentation
cabal upload --documentation dist-newstyle/sdist/numerical-analysis-lib-0.0.9-docs.tar.gz
```

### 4. Verify Package
   - Check package page on Hackage
   - Verify documentation is readable
   - Test installation from Hackage

## Post-Deployment

### 1. Create Release on GitHub
   - Tag version: `git tag v0.0.9`
   - Push tags: `git push --tags`
   - Create release on GitHub with changelog notes

### 2. Update Project Website (if applicable)
   - Update version numbers
   - Add new documentation
   - Update installation instructions

### 3. Announce Release
   - Update project status
   - Inform any existing users
   - Post on relevant forums or mailing lists

## Maintenance

### 1. Monitor Issues
   - Watch GitHub issues
   - Respond to bug reports
   - Track feature requests

### 2. Plan Next Version
   - Collect feedback
   - Prioritize improvements
   - Schedule updates

## Useful Commands

### Check package validity:
```bash
cabal check
```

### Clean build:
```bash
cabal clean
cabal build --enable-tests
```

### Update dependencies:
```bash
cabal update
cabal outdated
```

## Common Issues and Solutions

### 1. Documentation fails to generate
   - Check Haddock syntax
   - Verify all exported functions are documented
   - Ensure all necessary files are included in .cabal file

### 2. Upload fails
   - Verify package name availability on Hackage
   - Check version number hasn't been used
   - Ensure all dependencies are specified correctly

### 3. CI/CD failures
   - Check GHC version compatibility
   - Verify all dependencies are available
   - Review test suite stability

## Additional Resources

- [Hackage Documentation](https://hackage.haskell.org/upload)
- [Cabal User Guide](https://cabal.readthedocs.io/en/stable/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)