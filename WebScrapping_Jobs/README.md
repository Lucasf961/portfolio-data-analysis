## Objetivo

Projeto feito com a intenção de identificar as habilidades mais requisitadas nas descrições das vagas de emprego para analistas de dados no Linkedin.

## Visão Geral
1) Primeiro foi realizado o web scrapping na página de vagas do linkedin ([Link](https://www.linkedin.com/jobs)) utilizando um web driver do selenium para o navegador google chrome,e posteriormente gravado em um dataframe e salvo em csv. [Link do Script](https://github.com/Lucasf961/Projetos-data-analysis/blob/main/WebScrapping_Jobs/Jupyter_Notebooks/Scrapping.ipynb)

2) Na segunda parte do projeto, foi feita a limpeza e análise dos dados utilizando as bibliotecas nltk e pandas para limpeza e tratamento dos dados, e matplotlib, seaborn e wordcloud para a geração dos gráficos. [Link do Script](https://github.com/Lucasf961/Projetos-data-analysis/blob/main/WebScrapping_Jobs/Jupyter_Notebooks/Analysis.ipynb)

## Insights

As ferramentas e habilidades mais requisitadas dentre as 531 vagas extraídas somente no Brasil, foram:

![HardSkills](https://raw.githubusercontent.com/Lucasf961/Projetos-data-analysis/main/WebScrapping_Jobs/Images/wordcloud_hard-skills.png)
![HardSkills](https://raw.githubusercontent.com/Lucasf961/Projetos-data-analysis/main/WebScrapping_Jobs/Images/hardskills.png)

![SoftSkills](https://raw.githubusercontent.com/Lucasf961/Projetos-data-analysis/main/WebScrapping_Jobs/Images/wordcloud_soft-skills.png)
![SoftSkills](https://raw.githubusercontent.com/Lucasf961/Projetos-data-analysis/main/WebScrapping_Jobs/Images/softskills.png)



