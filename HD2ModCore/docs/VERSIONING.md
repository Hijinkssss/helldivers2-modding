# Version and compatibility policy

The first public version is `v0.3.0-dev`: a pre-1.0 Developer Preview, not three historical public releases. It preserves local development milestones in the changelog. API 1 identifies the facade family, not every optional extension or game-build support level.

Use semantic versions. During 0.x, document breaking public contract changes and bump the minor version; patch versions are compatible fixes. Prerelease labels identify previews. At 1.0 and later, breaking stable contracts require a major bump. Version comparisons must understand prereleases; do not compare arbitrary version strings lexicographically.

Specify the minimum Core release and API in consumer documentation/manifests. Journal's first public preview is tested against Core `0.3.0-dev`; Armory and the template require that preview's Input and ShortcutEligibility extension, checked at startup. Experimental surfaces may change with a documented preview minor bump. Loader compatibility is separately stated as tested v18 / API 1, not a promise about every later loader.

A game update never inherits old RVAs merely because the API version is unchanged. Build-dependent APIs require both module hashes and their runtime guards. Unsupported builds keep generic infrastructure available where possible and return errors for unavailable native state. New layouts need their own profile and evidence; changing an evidence label is not validation.
