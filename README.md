
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

mistral.ai::chat("what is mistral ?")
#> ── assistant ───────────────────────────────────────────────────────────────────
#> Mistral is a brand name for a type of paint spray gun that is widely used for both industrial and automotive applications. The Mistral gun is manufactured by the French company Binks, and it is known for its ability to deliver a consistent, high-quality coating with minimal overspray. The Mistral gun uses compressed air to atomize and propel the paint towards the surface being coated, and it is often used for large-scale painting projects where efficiency and uniformity are important. It is commonly used in industries such as automotive manufacturing, construction, and general industrial painting.
mistral.ai::stream("fun facts mistral.ai")
#> Mistral.ai is a cutting-edge company specializing in the development of large language models. Here are some fun facts about Mistral.ai:
#> 
#> 1. Mistral.ai was founded in 2021 by three French entrepreneurs: Clemence Mazel, Thomas Gottschalk, and Frédéric Bonnel.
#> 2. The name "Mistral" was inspired by the famous French poet and Nobel laureate, Frédéric Mistral, known for his mastery of the Provençal language.
#> 3. Mistral.ai's large language model, named "Mistral," is designed to understand and generate text in various languages, including English, French, Spanish, German, Italian, Portuguese, and Russian.
#> 4. Mistral.ai's language model is trained on a massive dataset, consisting of billions of words, allowing it to generate human-like text on a wide range of topics.
#> 5. Mistral.ai's model can be used for various applications, such as chatbots, content generation, language translation, and text summarization.
#> 6. Mistral.ai has partnerships with leading technology companies, including Microsoft, to integrate its language model into their products and services.
#> 7. Mistral.ai's team consists of experienced researchers and engineers in natural language processing, machine learning, and artificial intelligence.
#> 8. Mistral.ai has offices in Paris, France, and San Francisco, California.
#> 9. Mistral.ai's language model has been praised for its ability to generate creative and engaging text, making it a popular choice among writers, marketers, and content creators.
#> 10. Mistral.ai's mission is to make language models accessible to everyone, regardless of their technical expertise or resources, and to help people communicate more effectively and creatively in a globalized world.
```
