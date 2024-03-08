
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mistral.ai

<!-- badges: start -->

[![R-CMD-check](https://github.com/tadascience/mistral.ai/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/tadascience/mistral.ai/actions/workflows/R-CMD-check.yaml)
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
#> Mistral is a French painter, born on December 30, 1887, in Maussane-Vésigneau, near Arles, in the south of France. His real name was Marcel Theodore Aurel Gustave Clément, but he adopted the pseudonym "Mistral" as a homage to the famous Provencal poet Frédéric Mistral.
#> 
#> Mistral is best known for his vivid, colorful, and expressive paintings of the landscapes, people, and traditions of Provence. He was a key figure in the revival of interest in the art and culture of the region in the early 20th century.
#> 
#> Mistral's style was influenced by the Fauves, a group of artists who sought to break away from traditional representational art and explore the expressive use of color and form. He also drew inspiration from the Impressionist and Post-Impressionist movements, as well as from the folk art and traditions of Provence.
#> 
#> Mistral's work has been exhibited in major museums and galleries around the world, and he is considered one of the most important painters of the 20th century. He died in Paris on October 31, 1964.
mistral.ai::stream("fun facts mistral.ai")
#> Mistral AI is a cutting-edge company based in Paris, France, developing large language models. Here are some fun facts about Mistral AI:
#> 
#> 1. Founded in 2020: Mistral AI was founded in 2020 by Thomas Gotojevic, François-Xavier Carrier, and Adrien Duval, three researchers from the French National Institute for Computer Science and Applied Mathematics (INRIA).
#> 2. Focus on large language models: Mistral AI is known for its focus on developing large language models, which are artificial intelligence models capable of understanding and generating human-like text.
#> 3. Funding: The company has received significant funding, including a €100 million ($113 million) Series A round in March 2023, making it one of the largest AI funding rounds in Europe.
#> 4. Collaborations: Mistral AI has collaborated with various organizations, including the French National Center for Scientific Research (CNRS), the École des Ponts ParisTech, and the École Normale Supérieure (ENS).
#> 5. Open-source contributions: Mistral AI is committed to contributing to the open-source community. They have released various open-source projects, including the Mistral Model, a large language model that achieved state-of-the-art results on several benchmarks.
#> 6. Multilingual capabilities: Mistral AI's language models can generate text in multiple languages, including English, French, German, Italian, Spanish, and more.
#> 7. Interdisciplinary approach: Mistral AI's team comes from various backgrounds, including computer science, mathematics, physics, and linguistics, allowing for an interdisciplinary approach to AI research.
#> 8. Ethical considerations: Mistral AI is committed to addressing ethical considerations in AI research, including bias, fairness, and transparency. They have published papers on these topics and are actively engaging in discussions with stakeholders.
#> 9. Diverse applications: Mistral AI's language models have various applications, including language translation, text summarization, and text generation for creative writing and storytelling.
#> 10. Future plans: Mistral AI plans to continue developing large language models and exploring their applications in various fields, including education, healthcare, and creativity. They also aim to contribute to the development of a more ethical and transparent AI industry.
```
