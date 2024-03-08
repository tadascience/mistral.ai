
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mistral.ai

<!-- badges: start -->
<!-- badges: end -->

The goal of mistral.ai is to …

## Installation

You can install the development version of mistral.ai from
[GitHub](https://github.com/) with:

``` r
pak::pak("tadascience/mistral.ai")
```

## Example

``` r
# available models
mistral.ai::models()
#>  [1] "open-mistral-7b"       "mistral-tiny-2312"     "mistral-tiny"         
#>  [4] "open-mixtral-8x7b"     "mistral-small-2312"    "mistral-small"        
#>  [7] "mistral-small-2402"    "mistral-small-latest"  "mistral-medium-latest"
#> [10] "mistral-medium-2312"   "mistral-medium"        "mistral-large-latest" 
#> [13] "mistral-large-2402"    "mistral-embed"

# chat with mistral
mistral.ai::chat("is mistral the best wind ?")
#> ── assistant ───────────────────────────────────────────────────────────────────
#> Mistral is a specific name for a wind that originates in the Rhone Valley in France. It is known for being strong, cold, and dry, and it can blow consistently for several days at a time. Some people consider the Mistral to be one of the best winds for windsurfing and kitesurfing due to its strong and steady nature. However, whether the Mistral is the "best" wind depends on personal preference, as different people may have different definitions of what makes a wind ideal for their particular sport or activity. Some may prefer lighter winds, while others may enjoy stronger winds. Ultimately, the best wind is subjective and depends on the individual's skill level, equipment, and personal preference.

# mistral.ai::stream("")
```
