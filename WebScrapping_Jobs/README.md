## Objetivo
Projeto feito com a intenção de identificar as soft e hard skills mais requisitadas nas descrições das vagas de emprego do Linkedin para Analistas de Dados.

## Visão Geral
1) Inicialmente foi realizado o web scrapping na página de [vagas do linkedin](https://www.linkedin.com/jobs) utilizando um web driver do Selenium para o Google Chrome. Posteriormente os dados extraídos foram salvos em um arquivo csv. [Link do Notebook](https://github.com/Lucasf961/Projetos-data-analysis/blob/main/WebScrapping_Jobs/Jupyter_Notebooks/Scrapping.ipynb)

2) Na segunda etapa, foram utilizadas as bibliotecas NLTK e Pandas para limpeza e tratamento dos dados. E os gráficos com matplotlib, seaborn e wordcloud . [Link do Notebook](https://github.com/Lucasf961/Projetos-data-analysis/blob/main/WebScrapping_Jobs/Jupyter_Notebooks/Analysis.ipynb)

## Insights
As habilidades mais frequentes dentre as 531 vagas de analistas de dados extraídas no Brasil, foram:

### HardSkills
![HardSkills](https://raw.githubusercontent.com/Lucasf961/Projetos-data-analysis/main/WebScrapping_Jobs/Images/wordcloud_hard-skills.png)
![HardSkills](https://raw.githubusercontent.com/Lucasf961/Projetos-data-analysis/main/WebScrapping_Jobs/Images/hardskills.png)

### SoftSkills
![SoftSkills](https://raw.githubusercontent.com/Lucasf961/Projetos-data-analysis/main/WebScrapping_Jobs/Images/wordcloud_soft-skills.png)
![SoftSkills](https://raw.githubusercontent.com/Lucasf961/Projetos-data-analysis/main/WebScrapping_Jobs/Images/softskills.png)



